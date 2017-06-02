//
//  LFDNetworkModel.h
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LFDNetworkModel : MTLModel <MTLJSONSerializing>

+ (nonnull NSValueTransformer *)impl_dateJSONTransformer;
+ (nonnull NSValueTransformer *)impl_stringJSONTransformer;
+ (nonnull NSValueTransformer *)impl_numberJSONTransformer;

+ (nullable instancetype)modelByTest;

// 解析Model&构建出错Model
+ (nullable __kindof LFDNetworkModel*)handleResponseObject:(nonnull id)responseObject modelClass:(nonnull Class)modelClass successed:(nonnull BOOL *)successed;
+ (nullable __kindof LFDNetworkModel*)handleRequestError:(nonnull NSError *)error;

@end
