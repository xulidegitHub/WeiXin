//
//  NSString+Common.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/23.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Common)
- (float)stringWidthWithFont:(UIFont *)font height:(float)height;
- (float)stringHeightWithFont:(UIFont *)font width:(float)width;
- (CGSize)sizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width;
- (CGSize)sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize;
@end
