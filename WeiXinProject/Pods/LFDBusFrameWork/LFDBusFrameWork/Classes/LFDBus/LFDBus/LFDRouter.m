//
//  LFDRouter.m
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDRouter.h"
#import "LFDRoutingTable.h"
#import "LFDRoutingEntry.h"
#import "LFDRouteConnectorProtocol.h"
#import "UIViewController+LFDRouting.h"
#import "OTOObject.h"
//#import "MCAlertController.h"

@interface LFDRouter ()
{
    NSMutableArray<id<LFDRouteMonitoringProtocol>> *_monitors;
}

@end

@implementation LFDRouter

+ (nullable instancetype)shared {
    static LFDRouter *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LFDRouter alloc] init];
        }
    });
    return instance;
}

- (nullable instancetype)init {
    self = [super init];
    if (self) {
        _monitors = [NSMutableArray<id<LFDRouteMonitoringProtocol>> array];
    }
    return self;
}

- (void)dealloc {
    [_monitors removeAllObjects];
}

#pragma subscribe route event
- (void)subscribe:(nonnull id<LFDRouteMonitoringProtocol>)monitor {
    if (!monitor || ![monitor conformsToProtocol:@protocol(LFDRouteMonitoringProtocol)]) {
        return;
    }
    
    if (![_monitors containsObject:monitor]) {
        [_monitors addObject:monitor];
    }
}

- (void)unsubscribe:(nonnull id<LFDRouteMonitoringProtocol>)monitor {
    if (!monitor || ![monitor conformsToProtocol:@protocol(LFDRouteMonitoringProtocol)]) {
        return;
    }
    
    if ([_monitors containsObject:monitor]) {
        [_monitors removeObject:monitor];
    }
}

- (BOOL)notifyHookHandleOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules {
    for (id<LFDRouteMonitoringProtocol> monitor in _monitors) {
        if ([monitor respondsToSelector:@selector(hookHandleOpenURL:parameters:rules:)]) {
            if (![monitor hookHandleOpenURL:url parameters:params rules:rules]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (void)notifyPrevOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules {
    for (id<LFDRouteMonitoringProtocol> monitor in _monitors) {
        if ([monitor respondsToSelector:@selector(prevOpenURL:parameters:rules:)]) {
            [monitor prevOpenURL:url parameters:params rules:rules];
        }
    }
}

- (void)notifyPostOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules {
    for (id<LFDRouteMonitoringProtocol> monitor in _monitors) {
        if ([monitor respondsToSelector:@selector(postOpenURL:parameters:rules:)]) {
            [monitor postOpenURL:url parameters:params rules:rules];
        }
    }
}

#pragma process open url
- (void)openURL:(nonnull NSString *)url {
    [self openURL:url parameters:nil rules:nil];
}

- (void)openURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params {
    [self openURL:url parameters:params rules:nil];
}

- (BOOL)isValidURLString:(nonnull NSString *)url {
    NSString *reg = @"^lefinance://[a-zA-Z0-9\\-_]+(/[a-zA-Z0-9\\-_]+)*(\\?[a-zA-Z0-9\\-_]+=[a-zA-Z0-9\\.\\+\\-\\*\\(\\)_%]+(&[a-zA-Z0-9\\-_]+=[a-zA-Z0-9\\.\\+\\-\\*\\(\\)_%]+)*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [urlTest evaluateWithObject:url];
}

/**
 算法：
 a、遍历VC栈，构建栈上url辅助数据
   从keyWindow的rootVC开始进行遍历，根据是tabbar（selected）、navi（vc array）、普通VC（presenting）进行一级一级向上查找，若VC含有routeParams，则加入栈（array）
   每一项记录VC（url、参数、是否可重用）
 b、由栈顶逐级向栈底查找，寻找url相同的VC，
   找到，是否支持重用，支持重用，则回退到此，然后开始处理待转route栈
 c、查找route表，找到url对应的connector，取跳转url时所要使用的属性信息，
   检查pre_route是否有值，没有，由当前页面开始处理待route栈
   有，是否为root，是，不再向前查找，从此开始处理待route栈
   否则，继续压待转route栈，以pre_route为url进行查找，进入(b)
 */
- (void)openURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules {
    if (![self isValidURLString:url]) {
#if DEBUGTEST
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *message = [NSString stringWithFormat:@"url不符合规则:%@", url];
            MCAlertView *alertView = [MCAlertView initWithTitle:@"路由错误" message:message cancelButtonTitle:@"确定"];
            [alertView showWithCompletionBlock:^(NSInteger buttonIndex) {
                ;
            }];
        });
#endif
        return;
    }
    
    // 是否执行跳转回调
    if (![self notifyHookHandleOpenURL:url parameters:params rules:rules]) {
        return;
    }
    
    NSDictionary *destParams = [[LFDRoutingTable shared] mapURL:url parameters:params];
    if (!destParams) {
        return;
    }
    
    // 添加自定义规则
    if ([OTOObject isNonEmptyObject:rules ofClass:[NSDictionary class]]) {
        NSMutableDictionary *tempEntry = [destParams mutableCopy];
        tempEntry[kLFDRoutingEntryKey] = [(LFDRoutingEntry *)(destParams[kLFDRoutingEntryKey]) entryByUpdateRules:rules];
        destParams = [tempEntry copy];
    }
    
    // 构建当前VC栈
    NSMutableArray<UIViewController *> *fromStack = [NSMutableArray<UIViewController *> array];
    NSMutableDictionary<NSString *, UIViewController *> *fromStackAccess = [NSMutableDictionary<NSString *, UIViewController *> dictionary];
    UIViewController *topStackViewController = [self buildFromViewControllerStack:fromStack andAccess:fromStackAccess];
    
    // requires数据
//    NSMutableSet <NSString *> *requires = [NSMutableSet <NSString *> set];
    LFDRoutingEntry *destEntry = destParams[kLFDRoutingEntryKey];
//    [requires addObjectsFromArray:destEntry.require];
    
    NSString *destRouteURL = destParams[kLFDRoutingURLKey];
    UIViewController *destViewController = [fromStackAccess objectForKey:destRouteURL];
    // 单次回退即可
    if (destViewController && destViewController.reusable) {
        // 处理require
//        [self processRequires:requires viewController:topStackViewController complete:^(BOOL success) {
//            if (!success)
//                return;
        
            // 跳转前事件通知
            [self notifyPrevOpenURL:url parameters:params rules:rules];
            
            // 大数据lfd_widget_name参数传递
//            if ([LFDObjectUtil isNonEmptyString:destParams[kLFDRoutingParamWidgetNameKey]]) {
//                destViewController.lfd_widget_name = destParams[kLFDRoutingParamWidgetNameKey];
//            }
            
            // 找到了并且支持重用，直接跳转
            [self backToSpecificViewController:destViewController animated:YES];
            [destViewController refresh:destParams];
            
            // 跳转后通知
            [self notifyPostOpenURL:url parameters:params rules:rules];
//        }];
        
        return;
    }
    
    // 中间路由节点栈
    NSMutableArray<NSDictionary *> *viaParamsStack = [NSMutableArray array];
    [viaParamsStack addObject:destParams];
    
    // 构建中间路由节点
    LFDRoutingEntry *viaEntry = destEntry;
    UIViewController *viaViewController = [fromStackAccess objectForKey:viaEntry.viaRoute];
    while (viaEntry.viaRoute && (!viaViewController || !viaViewController.reusable)) {
        NSDictionary *viaParams = [[LFDRoutingTable shared] mapURL:viaEntry.viaRoute parameters:viaEntry.viaRouteParams];
        if (!viaParams) {
            // 不存在，从栈顶直接开始跳转
            break;
        }
        
        [viaParamsStack addObject:viaParams];
        
        // 添加require
        viaEntry = viaParams[kLFDRoutingEntryKey];
//        [requires addObjectsFromArray:viaEntry.require];
        
        viaViewController = [fromStackAccess objectForKey:viaEntry.viaRoute];
    }
    
    // 处理require
//    [self processRequires:requires viewController:topStackViewController complete:^(BOOL success) {
//        if (!success)
//            return;
    
        // 跳转前事件通知
        [self notifyPrevOpenURL:url parameters:params rules:rules];
        
        NSDictionary *routeParams = viaParamsStack[viaParamsStack.count-1];
        LFDRoutingEntry *routeEntry = routeParams[kLFDRoutingEntryKey];
        UIViewController *routeViewController = [fromStackAccess objectForKey:routeEntry.viaRoute];
        if (routeViewController && routeViewController.reusable) {
            // 回退到特定VC
            routeViewController = [self backToSpecificViewController:routeViewController animated:NO];
        } else {
            // 从栈顶开始
            routeViewController = topStackViewController;
        }
        
        // 从栈顶处理待跳转队列
        for (long i=viaParamsStack.count-1; i>=0; i--) {
            routeParams = viaParamsStack[i];
            routeEntry = routeParams[kLFDRoutingEntryKey];
            id<LFDRouteConnectorProtocol> connector = routeEntry.connector;
            
            if (routeEntry.customDisplay) {
                // tabbar的切换都由customDisplay处理
                routeViewController = [connector performCustomDisplay:routeViewController parameters:routeParams];
                
//                // 大数据lfd_widget_name参数传递
//                if ([LFDObjectUtil isNonEmptyString:routeParams[kLFDRoutingParamWidgetNameKey]]) {
////                    routeViewController.lfd_widget_name = routeParams[kLFDRoutingParamWidgetNameKey];
//                }
            } else {
                UIViewController *nextViewController = [connector createViewControllerWithEntry:routeEntry];
                nextViewController.routeParams = routeParams;
                
//                // 大数据lfd_widget_name参数传递
//                if ([LFDObjectUtil isNonEmptyString:routeParams[kLFDRoutingParamWidgetNameKey]]) {
////                    nextViewController.lfd_widget_name = routeParams[kLFDRoutingParamWidgetNameKey];
//                }
                
                LFDRoutingAppearMode appearMode = routeEntry.appearMode;
                if (appearMode == LFDRoutingAppearModeNone || appearMode == LFDRoutingAppearModePush) {
                    if (routeEntry.tabbarMode == LFDRoutingTabbarModeHidden) {
                        nextViewController.hidesBottomBarWhenPushed = YES;
                    }
                    
                    if (routeViewController.navigationController) {
                        [routeViewController.navigationController pushViewController:nextViewController animated:0==i];
                    } else if ([routeViewController isKindOfClass:[UINavigationController class]]) {
                        [(UINavigationController *)routeViewController pushViewController:nextViewController animated:0==i];
                    } else {
                        [routeViewController presentViewController:nextViewController animated:0==i completion:nil];
                    }
                } else if(appearMode == LFDRoutingAppearModePresent){
                    [routeViewController presentViewController:nextViewController animated:0==i completion:nil];
                }else{
                     [routeViewController presentViewController:nextViewController animated:NO completion:nil];
                }
                routeViewController = nextViewController;
            }
        }
        
        // 跳转后通知
        [self notifyPostOpenURL:url parameters:params rules:rules];
//    }];
}

+ (nullable UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootViewController) {
        return [self traverseFindTopViewController:rootViewController];
    }
    
    return nil;
}

+ (nullable UIViewController *)traverseFindTopViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedController = ((UITabBarController *)controller).selectedViewController;
        return [self traverseFindTopViewController:selectedController];
    } else if ([controller isKindOfClass:[UINavigationController class]]) {
        UIViewController *topController = ((UINavigationController *)controller).topViewController;
        return [self traverseFindTopViewController:topController];
    } else {
        UIViewController *presentController = controller.presentedViewController;
        if (presentController) {
            return [self traverseFindTopViewController:presentController];
        }
    }
    
    return controller;
}

/**
 构建当前的ViewController堆栈

 @param fromStack 输出参数，当前堆栈（只包含通过路由创建的VC）
 @param fromStackAccess 输出参数，用于快速访问当前堆栈的url到vc的映射表
 @return 栈顶VC，注意，栈顶VC可能并不是通过路由创建，所以其可能并不在fromStack内
 */
- (UIViewController *)buildFromViewControllerStack:(NSMutableArray<UIViewController *> *)fromStack andAccess:(NSMutableDictionary<NSString *, UIViewController *> *)fromStackAccess {
    if (!fromStack || !fromStackAccess) {
        return nil;
    }
    
    [fromStack removeAllObjects];
    [fromStackAccess removeAllObjects];
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootViewController) {
        return [self traverseViewController:rootViewController withFromStack:fromStack andAccess:fromStackAccess];
    }
    
    return nil;
}

- (UIViewController *)traverseViewController:(UIViewController *)controller withFromStack:(NSMutableArray<UIViewController *> *)fromStack andAccess:(NSMutableDictionary<NSString *, UIViewController *> *)fromStackAccess {
    NSDictionary *routeParams = controller.routeParams;
    if (routeParams) {
        [fromStack addObject:controller];
        [fromStackAccess setObject:controller forKey:routeParams[kLFDRoutingURLKey]];
    }
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedController = ((UITabBarController *)controller).selectedViewController;
        return [self traverseViewController:selectedController withFromStack:fromStack andAccess:fromStackAccess];
    } else if ([controller isKindOfClass:[UINavigationController class]]) {
        NSArray<__kindof UIViewController *> *viewControllers = ((UINavigationController *)controller).viewControllers;

        for (int i=0; i<viewControllers.count-1; i++) {
            UIViewController *viewController = viewControllers[i];
            routeParams = viewController.routeParams;
            if (routeParams) {
                [fromStack addObject:viewController];
                [fromStackAccess setObject:viewController forKey:routeParams[kLFDRoutingURLKey]];
            }
        }
        
        UIViewController *topController = ((UINavigationController *)controller).topViewController;
        return [self traverseViewController:topController withFromStack:fromStack andAccess:fromStackAccess];
    } else {
        UIViewController *presentController = controller.presentedViewController;
        if (presentController) {
            return [self traverseViewController:presentController withFromStack:fromStack andAccess:fromStackAccess];
        }
    }
    
    return controller;
}

/**
 回退到特定的VC

 @param controller 特定的VC
 @param animated 是否有动画
 @return 回退后位于栈顶的VC。特定VC若为Tabbar则为其选中的VC；特定VC若为navigation则为其根VC。
 */
- (UIViewController *)backToSpecificViewController:(UIViewController *)controller animated:(BOOL)animated {
    if (controller.navigationController && controller.navigationController.topViewController != controller) {
        [controller.navigationController popToViewController:controller animated:NO];
        [controller.navigationController dismissViewControllerAnimated:animated completion:nil];
        return controller;
    }
    
    if ([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController *)controller;
        if ([tabbarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)tabbarController.selectedViewController;
            [selectedController popToRootViewControllerAnimated:NO];
            [selectedController dismissViewControllerAnimated:animated completion:nil];
        } else {
            [tabbarController.selectedViewController dismissViewControllerAnimated:animated completion:nil];
        }
        
        return tabbarController.selectedViewController;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)controller;
        [navigationController popToRootViewControllerAnimated:NO];
        [navigationController dismissViewControllerAnimated:animated completion:nil];
        return navigationController.topViewController;
    }
    
    [controller dismissViewControllerAnimated:animated completion:nil];
    return controller;
}

#pragma requires
//- (void)processRequires:(NSSet<NSString *> *)requires viewController:(UIViewController *)topViewController complete:(void (^)(BOOL success))complete {
//    // 处理staff
//    if ([requires containsObject:@"staff"]) {
//        [LFDUserStaffHandle staffChannelHandler:^(BOOL isStaff){
//            if (complete) {
//                complete(isStaff);
//            }
//        } navigationVC:topViewController];
//        
//        return;
//    }
//    
//    // 处理login
//    if ([requires containsObject:@"login"]) {
//        [[SafeManage share] openWithSteps:@[@(kLoginStep), @(kSetGesStep)] successBlock:^(SafeManage *manage) {
//            if (complete) {
//                complete(manage.success);
//            }
//        }];
//        return;
//    }
//    
//    if (complete) {
//        complete(YES);
//    }
//}

@end
