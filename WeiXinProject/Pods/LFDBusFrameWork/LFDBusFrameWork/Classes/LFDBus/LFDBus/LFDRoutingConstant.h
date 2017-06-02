//
//  LFDRoutingConstant.h
//  LFDistributionApp
//
//  Created by fuliwu on 2016/11/27.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//
#ifndef LFDRoutingConstant_h
#define LFDRoutingConstant_h
#import <UIKit/UIKit.h>
/**
 routing entry路由表项支持的各种规则名称定义
 */
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryAcceleratorKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryReusableKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryCustomDisplayKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryAppearModeKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryTabbarModeKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryViaRouteKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryViaRouteParamsKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryRequireKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryRequireSeperator;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryDefaultParamsKey;

/**
 routing entry使用的其它常量定义
 */
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingEntryKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingURLKey;
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingRestfulParameterPrefix;

/**
 通用参数
 */
FOUNDATION_EXTERN NSString *__nonnull const kLFDRoutingParamWidgetNameKey;  // 设置lfd_widget_name参数

/**
 页面显示时的呈现方式
 */
typedef NS_OPTIONS(NSInteger, LFDRoutingAppearMode) {
    LFDRoutingAppearModeNone = 0,           // 不关心
    LFDRoutingAppearModePush = 1,           // push
    LFDRoutingAppearModePresent = 2,        // present
    LFDRoutingAppearModePresentNoAnimated = 3,    // present无动画
    LFDRoutingAppearModeDefault = LFDRoutingAppearModeNone
};

/**
 push时，Tabbar显示方式
 */
typedef NS_ENUM(NSInteger, LFDRoutingTabbarMode) {
    LFDRoutingTabbarModeNone = 0,           // 不关心
    LFDRoutingTabbarModeHidden = 1,         // push时，如果存在Tabbar，隐藏
    LFDRoutingTabbarModeShown = 2,          // push时，如果存在Tabbar，显示
    LFDRoutingTabbarModeDefault = LFDRoutingTabbarModeHidden
};

#endif /* LFDRoutingConstant_h */
