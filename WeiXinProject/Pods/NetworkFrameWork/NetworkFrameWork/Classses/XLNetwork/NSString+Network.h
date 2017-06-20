//
//  NSString+Network.h
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Network)
// 常用加密方法
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha512;
- (NSString *)encode;
- (NSString *)decode;
@end
