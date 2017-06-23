//
//  MessageDetailCell.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface MessageDetailCell : UITableViewCell
-(void)bubbleViewWithText:(NSString*)text andfrom:(BOOL)fromSelf andPosition:(float)position andTextFontSize:(CGFloat)fontSize andIconImage:(NSString*)iconImage;
- (void)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position;
+(CGFloat)cellHeightWithChatModel:(ChatModel*)chatModel;
@end
