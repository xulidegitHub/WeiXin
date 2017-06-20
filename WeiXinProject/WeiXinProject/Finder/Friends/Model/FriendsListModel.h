//
//  FriendsListModel.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/16.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <NetworkFrameWork/XLNetwork.h>
#import <Foundation/Foundation.h>
@class PageModel;
@class singleFriendMessageModel;
@interface FriendsListModel : XLNetworkModel

@property (nonatomic,strong) PageModel * _Nullable page;
+(instancetype _Nullable )modelByTest;
@end

@interface PageModel : XLNetworkModel
@property (nonatomic,copy) NSString * _Nullable totalCount;
@property (nonatomic,copy) NSString * _Nullable totalPageCount;
@property (nonatomic,copy) NSString * _Nullable pageSize;
@property (nonatomic,copy) NSString * _Nullable currentPageNo;
@property (nonatomic,strong) NSArray<singleFriendMessageModel*> * _Nullable dataList;
@end

@interface singleFriendMessageModel : XLNetworkModel
@property (nonatomic,copy) NSString * _Nullable iconName;
@property (nonatomic,copy) NSString * _Nullable iconTitle;
@property (nonatomic,copy) NSString * _Nullable content;
@property (nonatomic,copy) NSNumber * _Nullable picListCount;
@property (nonatomic,strong) NSArray * _Nullable picList;
@property (nonatomic,assign) CGFloat cellHeight;
@end
