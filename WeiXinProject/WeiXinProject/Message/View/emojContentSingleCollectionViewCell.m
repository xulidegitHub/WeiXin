

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
@property (nonatomic,assign) NSInteger btnIndex;

@end
@implementation emojContentSingleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.emojeBtn addTarget:self action:@selector(didClickEmojBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setImageWithData:(UIImage*)image andIndex:(NSInteger)index{
    [self.emojeBtn setBackgroundImage:image forState:UIControlStateNormal];
    self.emojeBtn.tag = index;
}

-(void)didClickEmojBtn{
    NSLog(@"%ld",self.emojeBtn.tag);
}

@end
