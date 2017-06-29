//
//  sendMesBottomView.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didClickEmojBtn)(NSInteger index);
@interface sendMesBottomView : UIView
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (nonatomic,copy)didClickEmojBtn clickEmojBtnBLock;
@end
