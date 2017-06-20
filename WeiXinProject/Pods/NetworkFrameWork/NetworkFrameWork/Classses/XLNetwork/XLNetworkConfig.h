//
//  XLNetworkConfig.h
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import <Foundation/Foundation.h>

@interface XLNetworkConfig : NSObject
/**
 设置根域名
 如jr.letv.com
 */
@property (nonatomic, copy) NSString* baseURL;
/**
 设置证书文件
 如@[le2017]  证书后缀为.der
 */
@property (nonatomic, strong) NSArray<NSString*>* fileNameArr;
/**
 设置是否使用https
 默认YES
 */
@property (nonatomic, assign) BOOL isHttps;

+ (instancetype) shareConfig;
@end
