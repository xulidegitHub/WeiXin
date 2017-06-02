//
//  NSURLSessionTask+LFDParam.m
//  LFDistributionApp
//
//  Created by 司小波 on 16/6/13.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "NSURLSessionTask+LFDParam.h"
#import <objc/runtime.h>
//请求时长上报时标记时间，计算时长


char key = '\0';

@implementation NSURLSessionTask (LFDParam)

- (void)setLfd_startDate:(NSDate *)lfd_startDate {
    objc_setAssociatedObject(self, &key, lfd_startDate, OBJC_ASSOCIATION_RETAIN);
}

- (NSDate *)lfd_startDate {
   return objc_getAssociatedObject(self, &key);
}

- (void)markDate {
    self.lfd_startDate = [NSDate date];
}



- (NSTimeInterval)lfd_duration {
    return [[NSDate date] timeIntervalSinceDate:self.lfd_startDate];
}

@end
