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
@end

@implementation XLFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finderTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.finderTabView.delegate = self;
    self.finderTabView.dataSource = self;
    [self.view addSubview:self.finderTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellIdentify"];
    if (!cell) {
      cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentify"];
    }
    cell.textLabel.text = @"朋友圈";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XLFriendsViewController *friendsVc = [[XLFriendsViewController alloc]init];
    friendsVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendsVc animated:YES];
}
@end
