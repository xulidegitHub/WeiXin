//
//  XLMineViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLMineViewController.h"
#import <Masonry.h>
@interface XLMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mineTableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation XLMineViewController
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[
                       @{@"firstSection":@[
                                 @{
                                    @"leftIconName":@"",
                                    @"userName":@"徐丽",
                                    @"userNumber":  @"微信号:xuli18211658058",
                                    }
                        ]},
                       @{@"secondSection":@[
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"钱包",
                                     @"userNumber":  @"",

                                     }
                                 ]},
                       @{@"thirdSection":@[
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"收藏",
                                     @"userNumber":  @"",
                                     
                                     },
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"相册",
                                     @"userNumber":  @"",
                                     
                                     },
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"卡包",
                                     @"userNumber":  @"",
                                     
                                     },
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"表情",
                                     @"userNumber":  @"",
                                     
                                     },


                                 
                                 ]},
                       @{@"forthSection":@[
                                 @{
                                     @"leftIconName":@"",
                                     @"userName":@"设置",
                                     @"userNumber":  @"",
                                     
                                     },
                                 
                                 ]}
                       ];
    
    }
    
    return _dataArray;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    self.view.backgroundColor = [UIColor whiteColor];
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.mineTableView.dataSource = self;
    self.mineTableView.delegate = self;
    [self.view addSubview:self.mineTableView];
 
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = @"nihao";
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
