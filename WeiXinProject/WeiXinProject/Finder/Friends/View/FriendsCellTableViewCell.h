//
//  FriendsCellTableViewCell.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/14.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsListModel.h"
@interface FriendsCellTableViewCell : UITableViewCell
-(void)setModel:(singleFriendMessageModel*)singleModel;
-(void)rowHeghtWithModel:(singleFriendMessageModel*)singleModel;
@end
