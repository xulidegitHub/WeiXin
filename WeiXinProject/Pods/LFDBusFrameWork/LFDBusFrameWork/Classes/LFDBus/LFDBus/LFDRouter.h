//
//  LFDRouter.h
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFDRoutingConstant.h"

/**
 route事件监控
 */
@protocol LFDRouteMonitoringProtocol <NSObject>

@optional

/**
 在执行打开url操作前，提供一个hook处理的机会

 @param url 目标页面
 @param params 传递给目标页面的参数
 @param rules 自定义规则
 @return
   YES: 继续执行打开url操作
   NO: 中断执行打开url操作
 */
- (BOOL)hookHandleOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules;

/**
 执行打开url操作前回调

 @param url 目标页面
 @param params 传递给目标页面的参数
 @param rules 自定义规则
 */
- (void)prevOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules;

/**
 执行打开url操作后回调
 
 @param url 目标页面
 @param params 传递给目标页面的参数
 @param rules 自定义规则
 */
- (void)postOpenURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules;

@end

@interface LFDRouter : NSObject

+ (nullable instancetype)shared;

/**
 获取当前栈顶的ViewController

 @return 当前栈顶的ViewController
 */
+ (nullable UIViewController *)topViewController;

/**
 订阅route事件
 
 几个回调时机：
   --处理前事件回调：（决定是否执行跳转）
   处理require
   --跳转前事件回调：
   跳转过程
   --跳转后事件回调：

 @param monitor 监控者
 */
- (void)subscribe:(nonnull id<LFDRouteMonitoringProtocol>)monitor;

/**
 取消订阅route事件
 
 @param monitor 监控者
 */
- (void)unsubscribe:(nonnull id<LFDRouteMonitoringProtocol>)monitor;

/**
 页面跳转，不需要传参

 @param url 目标页面，格式如下：
   lefinance://path1/path2/$param1/$param2?param3=value3&param4=value4
 */
- (void)openURL:(nonnull NSString *)url;

/**
 页面跳转，需要传参

 @param url 目标页面
 @param params 传递给目标页面的参数
 */
- (void)openURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params;

/**
 页面跳转，需要传参，以及更改默认跳转规则

 @param url 目标页面
 @param params 传递给目标页面的参数
 @param rules 自定义规则
 */
- (void)openURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params rules:(nullable NSDictionary *)rules;

@end
