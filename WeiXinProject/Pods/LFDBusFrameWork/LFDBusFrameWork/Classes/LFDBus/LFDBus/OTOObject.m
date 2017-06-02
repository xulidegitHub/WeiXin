




//
//  OTOObject.m
//  LFDBus
//
//  Created by 徐丽 on 17/4/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "OTOObject.h"

@implementation OTOObject
+ (BOOL)isEmptyObject:(NSObject *)object {
    if (nil == object || [object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSDictionary class]] && 0 == ((NSDictionary *)object).count) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSArray class]] && 0 == ((NSArray *)object).count) {
        return YES;
    }
    
    if ([object isKindOfClass:[NSString class]] && 0 == ((NSString *)object).length) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNonEmptyObject:(NSObject *)object ofClass:(Class)class {
    if (nil == object || ![object isKindOfClass:class]) {
        return NO;
    }
    
    if ([object isKindOfClass:[NSDictionary class]] && 0 == ((NSDictionary *)object).count) {
        return NO;
    }
    
    if ([object isKindOfClass:[NSArray class]] && 0 == ((NSArray *)object).count) {
        return NO;
    }
    
    if ([object isKindOfClass:[NSString class]] && 0 == ((NSString *)object).length) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isNonEmptyString:(NSString *)string {
    if (nil == string || ![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    return string.length?YES:NO;
}

@end
