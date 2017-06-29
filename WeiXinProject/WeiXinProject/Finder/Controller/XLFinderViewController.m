//
//  XLFinderViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLFinderViewController.h"
#import "XLFriendsViewController.h"
@interface XLFinderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *finderTabView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation XLFinderViewController
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[
                       
                       @{
                          @"rowData":@[
                                  @{
                                      @"imageName":@"ff_IconShowAlbum",
                                      @"title":@"朋友圈"
                                      }
                                  ],
                         
                        },
                       @{
                           @"rowData":@[
                                   @{
                                       @"imageName":@"ff_IconQRCode",
                                       @"title":@"扫一扫"
                                       },
                                   @{
                                       @"imageName":@"ff_IconShake",
                                       @"title":@"摇一摇"
                                       },
                                 ],
                           
                           },
                       @{
                           @"rowData":@[
                                   @{
                                       @"imageName":@"ff_IconLocationService",
                                       @"title":@"附近的人"
                                       },
                                   @{
                                       @"imageName":@"ff_IconBottle",
                                       @"title":@"漂流瓶"
                                       },
                                   ],
                           
                           },
                       @{
                           @"rowData":@[
                                   @{
                                       @"imageName":@"CreditCard_ShoppingBag",
                                       @"title":@"京东购物"
                                       },
                                   @{
                                       @"imageName":@"MoreGame",
                                       @"title":@"游戏"
                                       },
                                   ],
                           
                           },
                       @{
                           @"rowData":@[
                                   @{
                                       @"imageName":@"",
                                       @"title":@"小程序"
                                       },
                                  ],
                           
                           },
                       ];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.finderTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.finderTabView.delegate = self;
    self.finderTabView.dataSource = self;
    self.finderTabView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.finderTabView];
    self.navigationItem.title = @"发现";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *rowdataArray = self.dataArray[section][@"rowData"];
    return rowdataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    if (!cell) {
      cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentify"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"rowData"][indexPath.row][@"title"]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][@"rowData"][indexPath.row][@"imageName"]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        XLFriendsViewController *friendsVc = [[XLFriendsViewController alloc]init];
        friendsVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendsVc animated:YES];

    }
}
@end
