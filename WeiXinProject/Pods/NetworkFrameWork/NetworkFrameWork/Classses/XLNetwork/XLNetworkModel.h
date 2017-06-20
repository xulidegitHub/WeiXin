//
//  XLNetworkModel.h
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "AFNetworking/AFNetworking.h"
@interface XLNetworkModel :MTLModel <MTLJSONSerializing>
+ (nonnull NSValueTransformer *)impl_dateJSONTransformer;
+ (nonnull NSValueTransformer *)impl_stringJSONTransformer;
+ (nonnull NSValueTransformer *)impl_numberJSONTransformer;

+ (nullable instancetype)modelByTest;

// 解析Model&构建出错Model
+ (nullable __kindof XLNetworkModel*)handleResponseObject:(nonnull id)responseObject modelClass:(nonnull Class)modelClass successed:(nonnull BOOL *)successed;
+ (nullable __kindof XLNetworkModel*)handleRequestError:(nonnull NSError *)error;

@end
