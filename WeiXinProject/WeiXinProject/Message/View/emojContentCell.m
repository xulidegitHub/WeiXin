//
//  emojContentCell.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "emojContentCell.h"
#import "emojContentSingleCollectionViewCell.h"
@interface emojContentCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *emojontentCollectionView;

@end
@implementation emojContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.emojontentCollectionView.delegate = self;
    self.emojontentCollectionView.dataSource = self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 49;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    emojContentSingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellSingleID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"emojContentSingleCollectionViewCell" owner:self options:nil].lastObject;
    }
    return cell;
}
@end
