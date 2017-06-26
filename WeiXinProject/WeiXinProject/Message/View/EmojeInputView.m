//
//  EmojeInputView.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "EmojeInputView.h"
#import "UIView+Frame.h"
#import "emojContentCell.h"
@interface EmojeInputView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic,strong)UIPageControl *pageControl;
@end
@implementation EmojeInputView

- (void)drawRect:(CGRect)rect {
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayOut];
        self.collectionview.dataSource = self;
        self.collectionview.delegate = self;
        [self addSubview:self.collectionview];
    }
    return self;

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    emojContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"emojContentCell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
