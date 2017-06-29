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
@property (weak, nonatomic) IBOutlet UICollectionView *emojcontentCollectionView;
@property (strong, nonatomic) NSArray *dataArray;

@end
@implementation emojContentCell

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake(35,35);
    flowLayOut.minimumInteritemSpacing = ([UIScreen mainScreen].bounds.size.width-35*7)/6;
    self.emojcontentCollectionView.delegate = self;
    self.emojcontentCollectionView.dataSource = self;
    [self.emojcontentCollectionView registerNib:[UINib nibWithNibName:@"emojContentSingleCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellSingleID"];
    self.emojcontentCollectionView.collectionViewLayout = flowLayOut;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)setEmojDataArray:(NSArray*)emojDataArray{
    self.dataArray = emojDataArray;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    emojContentSingleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellSingleID" forIndexPath:indexPath];
    [cell setImageWithData:(UIImage*)self.dataArray[indexPath.row] andIndex:indexPath.row];
    return cell;
}
@end
