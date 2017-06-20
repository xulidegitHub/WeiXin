//
//  XLNetworkModelResponse.h
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import <Foundation/Foundation.h>
#import "XLNetwork.h"
typedef NS_ENUM(NSInteger, LFDNetworkResponseResult) {
    NetworkResponseResultOK = 1,
    NetworkResponseResultError = 0
};
@interface XLNetworkModelResponse : MTLModel
@property (nonatomic, readonly, assign) LFDNetworkResponseResult result;
@property (nonatomic, readonly, assign) NSInteger code;
@property (nonatomic, readonly, copy) NSString *message;
@property (nonatomic, readonly, strong) id data;
@property (nonatomic, readonly, getter=isValid, assign) BOOL valid;

- (instancetype)initWithResponseObject:(id)responseObject error:(NSError **)error;

@end
