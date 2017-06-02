//
//  OTOObject.h
//  LFDBus
//
//  Created by 徐丽 on 17/4/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTOObject : NSObject
+ (BOOL)isEmptyObject:(NSObject *)object;
+ (BOOL)isNonEmptyObject:(NSObject *)object ofClass:(Class)class;
+ (BOOL)isNonEmptyString:(NSString *)string;
@end
