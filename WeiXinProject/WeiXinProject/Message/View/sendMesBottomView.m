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
    self.leftTip.tag = 1001;
    self.rightTip.tag = 1002;
    self.rightSecondTip.tag = 1003;
    self.inputTextView.layer.cornerRadius = 0.5;
    self.leftTip.userInteractionEnabled = YES;
    self.rightSecondTip.userInteractionEnabled = YES;
    self.rightTip.userInteractionEnabled = YES;
    UITapGestureRecognizer *emojGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickEmojBtn)];
    [self.rightTip addGestureRecognizer:emojGesture];
    UITapGestureRecognizer *recordGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickRecordBtn)];
    [self.leftTip addGestureRecognizer:recordGesture];
    UITapGestureRecognizer *inputGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickInputBtn)];
    [self.rightSecondTip addGestureRecognizer:inputGesture];
}

-(void)didClickEmojBtn{
    if (_clickEmojBtnBLock) {
        _clickEmojBtnBLock(self.rightTip.tag);
    }

}

-(void)didClickRecordBtn{
    if (_clickEmojBtnBLock) {
        _clickEmojBtnBLock(self.leftTip.tag);
    }
}

-(void)didClickInputBtn{
    if (_clickEmojBtnBLock) {
        _clickEmojBtnBLock(self.rightSecondTip.tag);
    }
}



@end
