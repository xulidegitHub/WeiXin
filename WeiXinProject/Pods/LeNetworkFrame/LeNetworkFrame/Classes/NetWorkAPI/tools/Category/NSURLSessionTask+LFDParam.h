//
//  NSURLSessionTask+LFDParam.h
//  LFDistributionApp
//
//  Created by 司小波 on 16/6/13.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (LFDParam)
@property (nonatomic, strong) NSDate *lfd_startDate;   //标记开始时刻

//标记时间
- (void)markDate;
//请求耗时
- (NSTimeInterval)lfd_duration;



@end
