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
@property (nonatomic,strong)NSArray *dataSourceArray;
@property (nonatomic,strong)NSMutableArray *singleCellMutArray;
@end
@implementation EmojeInputView

-(NSArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSArray array];
    }
    return _dataSourceArray;
}

-(NSMutableArray *)singleCellMutArray{
    if (!_singleCellMutArray) {
        _singleCellMutArray = [NSMutableArray array];
    }
    return _singleCellMutArray;
}

- (void)drawRect:(CGRect)rect {
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.itemSize = CGSizeMake(frame.size.width, frame.size.height);
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayOut.minimumLineSpacing = 0;
        self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:flowLayOut];
        self.collectionview.dataSource = self;
        self.collectionview.delegate = self;
        self.collectionview.bounces = YES;
        self.collectionview.pagingEnabled = YES;
        [self.collectionview registerNib:[UINib nibWithNibName:@"emojContentCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        [self addSubview:self.collectionview];
    }
    return self;

}

-(void)reloadDataWithArray:(NSArray *)dataArray{
    self.dataSourceArray = [self splitArray:dataArray withSubSize:35];
    [self.collectionview reloadData];

}

- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];  
    }  
    
    return [arr copy];  
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    emojContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    [cell setEmojDataArray:self.dataSourceArray[indexPath.row]];
    return cell;
}
@end
