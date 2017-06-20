//
//  XLNetworkConfig.m
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import "XLNetworkConfig.h"
@implementation XLNetworkConfig
+ (instancetype) shareConfig{
    static XLNetworkConfig *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[XLNetworkConfig alloc] init];
        obj.isHttps = YES;
    });
    return obj;
}
@end
