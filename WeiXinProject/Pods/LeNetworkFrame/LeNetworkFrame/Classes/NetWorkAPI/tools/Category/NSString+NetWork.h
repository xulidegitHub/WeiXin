//
//  NSString+NetWork.h
//  LeFinanceO2O
//
//  Created by letv on 2017/4/20.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NetWork)
// 常用加密方法
- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)sha512;
- (NSString *)encode;
- (NSString *)decode;
@end
