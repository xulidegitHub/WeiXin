//
//  LFDRouteConnectorProtocol.h
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LFDRoutingEntry;

@protocol LFDRouteConnectorProtocol <NSObject>

/**
 connector可以处理的url及对应的entry
 */
@property (nonatomic, readonly, strong) NSDictionary<NSString *, LFDRoutingEntry *> * _Nonnull entries;

@optional
/**
 创建ViewController

 @param entry 创建ViewController的routing entry
 @return 被创建的ViewController
 */
- (nullable UIViewController *)createViewControllerWithEntry:(nonnull LFDRoutingEntry *)entry;

/**
 对于要求自定义处理ViewController显示过程的entry，entry的customDisplay为YES，执行显示处理

 @param topViewController 当前栈顶VC
 @param params 显示参数
 @return 完成后的栈顶VC
 */
- (nullable UIViewController *)performCustomDisplay:(nonnull UIViewController *)topViewController parameters:(nonnull NSDictionary *)params;

@end
