//
//  LFDRoutingEntry.h
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFDRoutingConstant.h"

@protocol LFDRouteConnectorProtocol;

@interface LFDRoutingEntry : NSObject

+ (nullable instancetype)entryWithConnector:(nonnull id<LFDRouteConnectorProtocol>)connector rules:(nullable NSDictionary *)rules;

/**
 为了支持自定义跳转规则

 @param rules 需要更新的规则
 @return 更新后的新routing entry
 */
- (nullable instancetype)entryByUpdateRules:(nonnull NSDictionary *)rules;

@property (nonatomic, readonly, weak) id<LFDRouteConnectorProtocol> _Nullable connector;

/**
 用于加速connector查找对应的ViewController的辅助对象
 */
@property (nonatomic, readonly, assign) id _Nullable accelerator;

/**
 是否可以重用
 */
@property (nonatomic, readonly, assign) BOOL reusable;

/**
 是否由connector负责处理ViewController的显示
 */
@property (nonatomic, readonly, assign) BOOL customDisplay;

/**
 本ViewController的呈现方式
 */
@property (nonatomic, readonly, assign) LFDRoutingAppearMode appearMode;

/**
 push时tabbar的显示方式
 */
@property (nonatomic, readonly, assign) LFDRoutingTabbarMode tabbarMode;

/**
 显示本页面前必须要途经的页面, 可能为空, 表明无需任何依赖
 */
@property (nonatomic, readonly, copy) NSString * _Nullable viaRoute;

/**
 为途径路由设定的参数，可能为空，表明无需传参
 */
@property (nonatomic, readonly, copy) NSDictionary * _Nullable viaRouteParams;

/**
 显示本页面前的必要条件, 可以有多个必要条件, 目前支持:
 login: 需要登录
 staff: 员工身份
 */
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable require;

/**
 默认参数，当外界未指定时生效，外界有指定则覆盖默认值
 */
@property (nonatomic, readonly, copy) NSDictionary * _Nullable defaultParams;

@end
