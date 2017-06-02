//
//  LFDObjectUtil.h
//  LFDistributionApp
//
//  Created by jimi on 16/4/22.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LFDObjectUtil : NSObject

+ (BOOL)isEmptyObject:(NSObject *)object;
+ (BOOL)isNonEmptyObject:(NSObject *)object ofClass:(Class)class;
+ (BOOL)isNonEmptyString:(NSString *)string;

@end
