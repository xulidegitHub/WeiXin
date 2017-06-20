//
//  FriendsViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLFriendsViewController.h"
#import "GlobalDefines.h"
#import "UIView+Frame.h"
#import "FriendsHeadView.h"
#import "FriendsCellTableViewCell.h"
#import "FriendsListModel.h"
#import "XLNetworkSampleModel.h"
@interface XLFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *friendsTabView;
@property (nonatomic,strong)FriendsListModel *frinedsListModel;
@property (nonatomic,strong)singleFriendMessageModel *singleFriendMesModel;
@property (nonatomic,strong) NSArray *dataArray;
@end   

@implementation XLFriendsViewController

-(NSArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    self.friendsTabView.delegate = self;
    self.friendsTabView.dataSource = self;
   FriendsHeadView *tabHeadView = [[FriendsHeadView alloc]initWithFrame:CGRectMake(0,0,self.friendsTabView.width, 200)];
    tabHeadView.backgroundColor = [UIColor blueColor];
    self.friendsTabView.tableHeaderView = tabHeadView;
    self.friendsTabView.estimatedRowHeight = 50;
    self.friendsTabView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.friendsTabView];
    [self request];
}

-(void)request{
    self.frinedsListModel = [FriendsListModel modelByTest];
    self.dataArray = [self.frinedsListModel.page.dataList copy];
    [self.friendsTabView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendsCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[FriendsCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    [cell setModel:self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell rowHeghtWithModel:self.dataArray[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.singleFriendMesModel= self.dataArray[indexPath.row];
    return self.singleFriendMesModel.cellHeight;
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
