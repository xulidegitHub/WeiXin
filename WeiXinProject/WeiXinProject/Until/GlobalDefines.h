//
//  GlobalDefines.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/12.
//  Copyright © 2016年 GSD. All rights reserved.
//

#ifndef GlobalDefines_h
#define GlobalDefines_h

#define SDColor(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a]

#define Global_tintColor [UIColor colorWithRed:0 green:(190 / 255.0) blue:(12 / 255.0) alpha:1]

#define Global_mainBackgroundColor SDColor(248, 248, 248, 1)

#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

#define DAY @"day"

#define NIGHT @"night"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define DECLARE_WEAK_SELF __typeof(&*self) __weak weakSelf = self
#define DECLARE_STRONG_SELF __typeof(&*self) __strong strongSelf = weakSelf
#define tintGreenColor SDColor(26,178,11,1)
#endif
