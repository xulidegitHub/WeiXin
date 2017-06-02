//
//  FriendsHeadView.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "FriendsHeadView.h"
#import <Masonry.h>
#import "GlobalDefines.h"
@interface FriendsHeadView()
@property(nonatomic,strong)UIImageView *backGroundImageView;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *tipLabel;
@end
@implementation FriendsHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpHeadView];
    }
    return self;
}

-(void)setUpHeadView{
    DECLARE_WEAK_SELF;
    self.backGroundImageView = [[UIImageView alloc]init];
    [self addSubview:self.backGroundImageView];

    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        DECLARE_STRONG_SELF;
        make.left.equalTo(strongSelf.mas_left).offset(0);
        make.top.equalTo(strongSelf.mas_top).with.offset(0);
        make.width.equalTo(strongSelf.mas_width);
        make.height.equalTo(strongSelf.mas_height);
    }];
    self.backGroundImageView.backgroundColor = [UIColor grayColor];
    self.iconImageView = [[UIImageView alloc]init];
     [self addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        DECLARE_STRONG_SELF;
        make.right.equalTo(strongSelf.mas_right).with.offset(-10);
        make.bottom.equalTo(strongSelf.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    self.iconImageView.backgroundColor = [UIColor greenColor];
   
    self.tipLabel = [[UILabel alloc]init];
     [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        DECLARE_STRONG_SELF;
        make.right.equalTo(strongSelf.iconImageView.mas_left).with.offset(-20);
        make.bottom.equalTo(strongSelf.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(100);
    }];
    self.tipLabel.text = @"徐丽klfjlksadjflsjdflkj";
   
}


@end
