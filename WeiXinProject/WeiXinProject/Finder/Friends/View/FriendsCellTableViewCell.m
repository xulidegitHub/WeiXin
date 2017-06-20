//
//  FriendsCellTableViewCell.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/14.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "FriendsCellTableViewCell.h"
#import <Masonry.h>
#import "PicListView.h"
@implementation FriendsCellTableViewCell{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *contentLabel;
    PicListView *picListView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        headImageView = [[UIImageView alloc] init];
        headImageView.image = [UIImage imageNamed:@"shareImage"];
        [self addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
             make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        nameLabel = [[UILabel alloc] init];
        nameLabel.text = @"天天天蓝";
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headImageView.mas_top);
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"tiandlksfjksdjflsdfjksdflejrioemskdlle;kioarjndfsmk,l;dewirujfghnxmdksl;;bfhjdnsvjklmedjfhcnvxjvkldsdkvndkfgelsfdhgdkhgkdjfklasfdksdfjlkadfjklsdfjasldkfjalsdjflasjkdflksjflsjdfsldfjaklfjaksjdfkasjfkasfalkfjsldjflaskfjs";
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headImageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(nameLabel.mas_bottom).offset(5);
        }];
        [contentLabel.superview layoutIfNeeded];
        picListView = [[PicListView alloc] init];
        [self addSubview:picListView];
        [picListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(5);
            make.left.equalTo(contentLabel.mas_left);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-CGRectGetMinX(contentLabel.frame)-10,[UIScreen mainScreen].bounds.size.width-CGRectGetMinX(contentLabel.frame)-10));
        }];
        picListView.origionWidth = [UIScreen mainScreen].bounds.size.width-CGRectGetMinX(contentLabel.frame)-10;
        picListView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setModel:(singleFriendMessageModel*)singleModel{
    headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",singleModel.iconName]];
    nameLabel.text = [NSString stringWithFormat:@"%@",singleModel.iconTitle];
    contentLabel.text = [NSString stringWithFormat:@"%@",singleModel.content];
    [picListView createSubViewWithsourceImageArray:singleModel.picList];
   }

-(void)rowHeghtWithModel:(singleFriendMessageModel*)singleModel{
    CGFloat cellHeight;
    if (singleModel.picList.count<=0) {
        cellHeight = CGRectGetMaxY(contentLabel.frame);
    }else if(1>=singleModel.picList.count&&singleModel.picList.count>=3){
       cellHeight = CGRectGetMaxY(contentLabel.frame)+100;
    }else if(4<=singleModel.picList.count&&singleModel.picList.count<=6){
        cellHeight = CGRectGetMaxY(contentLabel.frame)+190;
    }else{
        cellHeight = CGRectGetMaxY(contentLabel.frame)+280;
    }
    singleModel.cellHeight = cellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
