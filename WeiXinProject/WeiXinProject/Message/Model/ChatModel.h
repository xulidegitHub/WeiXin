//
//  ChatModel.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/23.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <NetworkFrameWork/XLNetwork.h>
#import <UIKit/UIKit.h>
@interface ChatModel : XLNetworkModel
@property(nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,copy) NSString *chatContent;
@end
