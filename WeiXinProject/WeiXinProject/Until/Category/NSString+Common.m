//
//  NSString+Common.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/23.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)
- (float)stringWidthWithFont:(UIFont *)font height:(float)height
{
    if (self == nil || self.length == 0) {
        return 0;
    }
    NSString *copyString = [NSString stringWithFormat:@"%@", self];
    CGSize constrainedSize = CGSizeMake(999999, height);
    CGSize size  = CGSizeZero;
    size = [copyString boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    return size.width+1.0;
}

- (float)stringHeightWithFont:(UIFont *)font width:(float)width
{
    if (self == nil || self.length == 0) {
        return 0;
    }
    
    NSString *copyString = [NSString stringWithFormat:@"%@", self];
    
    CGSize constrainedSize = CGSizeMake(width, 999999);
    CGSize size  = CGSizeZero;
    
    size = [copyString boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size;
    return size.height+1.0;
    
    
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize width:(CGFloat)width {
    return [self sizeWithFontSize:fontSize maxSize:CGSizeMake(width, [UIScreen mainScreen].bounds.size.width - 100)];
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize {
    // 设置Label的字体 HelveticaNeue  Courier
    UIFont *fnt = [UIFont systemFontOfSize:fontSize];
    // 根据字体得到NSString的尺寸
    CGSize size = [self boundingRectWithSize:CGSizeMake(maxSize.width, maxSize.height) options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : fnt} context:nil].size;
    
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    
    return size;
}

@end
