         //
//  PicListView.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/15.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "PicListView.h"
#import <Masonry/Masonry.h>
#import "UIView+Frame.h"
@interface PicListView()
@property (nonatomic,assign) CGRect rect;

@end
@implementation PicListView
-(void)layoutSubviews{
    [super layoutSubviews];
    self.rect = self.frame;
}
-(void)createSubViewWithsourceImageArray:(NSArray*)imageListArray{
   if(imageListArray.count>6&&imageListArray.count<=9){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(280);
            make.width.mas_equalTo(_origionWidth);
        }];
        [self layoutIfNeeded];
        [self createCollectionViewWithImageNameArray:imageListArray andColumnCount:3 andViewWidth:80 andViewHeight:80];
    }else if(imageListArray.count==4){
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_origionWidth-80);
                make.height.mas_equalTo(190);
            }];
        [self layoutIfNeeded];
         [self createCollectionViewWithImageNameArray:imageListArray andColumnCount:2 andViewWidth:80 andViewHeight:80];
    }else if(imageListArray.count == 0){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeZero);
        }];
        [self layoutIfNeeded];
    }else if(imageListArray.count>=1&&imageListArray.count<=3){
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_origionWidth);
            make.height.mas_equalTo(100);
        }];
        [self layoutIfNeeded];
        [self createCollectionViewWithImageNameArray:imageListArray andColumnCount:3 andViewWidth:80 andViewHeight:80];
    }else if(imageListArray.count>=5&&imageListArray.count<=6){
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(190);
             make.width.mas_equalTo(_origionWidth);
        }];
        [self layoutIfNeeded];
        [self createCollectionViewWithImageNameArray:imageListArray andColumnCount:3 andViewWidth:80 andViewHeight:80];
    }
}

-(instancetype)createCollectionViewWithImageNameArray:(NSArray*)imageNameArray andColumnCount:(NSInteger)columnCount andViewWidth:(CGFloat)viewWidth andViewHeight:(CGFloat)viewHeight{

        CGFloat margin = (self.rect.size.width-columnCount*viewWidth)/(columnCount+1);
        NSInteger count = imageNameArray.count;
        for (int i = 0; i<count; i++) {
            //行号
            NSInteger row =i/columnCount;
            //列号
            NSInteger line =i%columnCount;
            CGFloat imageViewX = margin+(margin+viewWidth)*line;
            CGFloat imageViewY = 10 +(10+viewHeight)*row;
            //创建控件
            UIImageView *imageListView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX,imageViewY,viewWidth,viewHeight)];
            imageListView.image = [UIImage imageNamed:(NSString*)imageNameArray[i]];
            [self addSubview:imageListView];
        }
    return self;
}

@end
