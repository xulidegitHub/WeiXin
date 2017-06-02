//
//  LFDNetworkRawResponse.h
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger, LFDNetworkResponseResult) {
    LFDNetworkResponseResultOK = 1,
    LFDNetworkResponseResultError = 0
};

@interface LFDNetworkRawResponse : MTLModel

@property (nonatomic, readonly, assign) LFDNetworkResponseResult result;
@property (nonatomic, readonly, assign) NSInteger code;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, strong) id data;
@property (nonatomic, readonly, getter=isValid, assign) BOOL valid;

- (instancetype)initWithResponseObject:(id)responseObject error:(NSError **)error;

@end
