//
//  UIViewController+LFDRouting.m
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "UIViewController+LFDRouting.h"
#import "LFDRoutingConstant.h"
#import "OTOObject.h"
#import <objc/runtime.h>

@implementation UIViewController (LFDRouting)

static char kAssociatedRouteParamsObjectKey;

- (void)setRouteParams:(nullable NSDictionary *)params {
    objc_setAssociatedObject(self, &kAssociatedRouteParamsObjectKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable NSDictionary *)routeParams {
    NSDictionary *params = (NSDictionary *)objc_getAssociatedObject(self, &kAssociatedRouteParamsObjectKey);
    if ([OTOObject isNonEmptyObject:params ofClass:[NSDictionary class]]) {
        return params;
    }
    
    return nil;
}

- (NSString *)routeURL {
    NSDictionary *params = (NSDictionary *)objc_getAssociatedObject(self, &kAssociatedRouteParamsObjectKey);
    if ([OTOObject isNonEmptyObject:params ofClass:[NSDictionary class]]) {
        return params[kLFDRoutingURLKey];
    }
    
    return nil;
}

- (BOOL)reusable {
    NSDictionary *params = (NSDictionary *)objc_getAssociatedObject(self, &kAssociatedRouteParamsObjectKey);
    if ([OTOObject isNonEmptyObject:params ofClass:[NSDictionary class]]) {
        if ([OTOObject isNonEmptyObject:params[kLFDRoutingEntryReusableKey] ofClass:[NSNumber class]]) {
            return ((NSNumber *)params[kLFDRoutingEntryReusableKey]).boolValue;
        }
    }
    
    return YES;
}

- (void)refresh:(nullable NSDictionary *)params {
    NSLog(@"!!!important ===== 对于要做数据刷新的VC，需要自己实现refresh方法!!!!! =====");
}

@end
