//
//  UIViewController+LFDRouting.h
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LFDRouting)

/**
 route时传入参数
 */
@property (nonatomic, strong) NSDictionary * _Nullable routeParams;

/**
 route url参数
 */
@property (nonatomic, readonly, copy) NSString * _Nullable routeURL;

/**
 是否可以重用
 */
@property (nonatomic, readonly, assign) BOOL reusable;

/**
 支持重用，刷新数据时框架调用的方法

 @param params 新传入的参数
 */
- (void)refresh:(nullable NSDictionary *)params;

@end
