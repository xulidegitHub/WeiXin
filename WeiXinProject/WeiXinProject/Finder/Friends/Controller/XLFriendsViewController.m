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
@interface XLFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *friendsTabView;
@end

@implementation XLFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight) style:UITableViewStylePlain];
    self.friendsTabView.delegate = self;
    self.friendsTabView.dataSource = self;
   FriendsHeadView *tabHeadView = [[FriendsHeadView alloc]initWithFrame:CGRectMake(0,0,self.friendsTabView.width, 200)];
    tabHeadView.backgroundColor = [UIColor blueColor];
    self.friendsTabView.tableHeaderView = tabHeadView;
    [self.view addSubview:self.friendsTabView];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = @"你好";
    return cell;

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
