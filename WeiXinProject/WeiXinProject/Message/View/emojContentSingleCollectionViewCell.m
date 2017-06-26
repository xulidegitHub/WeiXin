

//
//  emojContentSingleCollectionViewCell.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "emojContentSingleCollectionViewCell.h"
@interface emojContentSingleCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *emojeBtn;

@end
@implementation emojContentSingleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.emojeBtn.backgroundColor = [UIColor redColor];
    
}

@end
