//
//  LFDRoutingTable.h
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LFDRouteConnectorProtocol;
@class LFDRoutingEntry;

@interface LFDRoutingTable : NSObject

+ (nullable instancetype)shared;

/**
 注册connector所包含的routing entries

 @param connector 被注册的connector
 */
- (void)registerConnector:(nonnull id<LFDRouteConnectorProtocol>)connector;

/**
 注销connector所包含的routing entries
 
 @param connector 被注销的connector
 */
- (void)unregisterConnector:(nonnull id<LFDRouteConnectorProtocol>)connector;

/**
 查找路由表，寻找url对应的routing entry

 @param url 需要查找的地址
 @param params 访问参数
 @return 返回字典对象，包含如下：
   kLFDRoutingEntryKey : 找到的routing entry
   kLFDRoutingURLKey : 解析后的最终URL
   其它 : 传入及解析后的所有参数
 */
- (nullable NSDictionary *)mapURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params;

@end
