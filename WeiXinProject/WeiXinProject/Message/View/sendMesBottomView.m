//
//  sendMesBottomView.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "sendMesBottomView.h"
@interface sendMesBottomView()
@property (weak, nonatomic) IBOutlet UIImageView *leftTip;
@property (weak, nonatomic) IBOutlet UIImageView *rightTip;
@property (weak, nonatomic) IBOutlet UIImageView *rightSecondTip;


@end
@implementation sendMesBottomView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.inputTextView.layer.cornerRadius = 0.5;
    self.rightSecondTip.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickEmojBtn)];
    [self.rightTip addGestureRecognizer:tap];
}

-(void)didClickEmojBtn{


}

@end
