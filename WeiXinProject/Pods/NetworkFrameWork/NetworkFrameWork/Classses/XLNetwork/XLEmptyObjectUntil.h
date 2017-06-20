//
//  XLEmptyObjectUntil.h
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import <Foundation/Foundation.h>

@interface XLEmptyObjectUntil : NSObject
+ (BOOL)isEmptyObject:(NSObject *)object;
+ (BOOL)isNonEmptyObject:(NSObject *)object ofClass:(Class)class;
+ (BOOL)isNonEmptyString:(NSString *)string;
@end
