//
//  XLMineViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 17/4/26.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLMineViewController.h"
#import <Masonry.h>
@interface XLMineViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation XLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.label = [[UILabel alloc] init];
    self.label.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(40);
    }];
    self.label.text = @"ni";
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.top.equalTo(self.label).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    btn.backgroundColor = [UIColor redColor];
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.numberOfLines = 0;
    [self.view addSubview:heightLabel];
    [heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(110);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(btn.mas_bottom).offset(50);
    }];
    heightLabel.text = @"lksdfjklasdjflkasjdfkljasdklfdskfjksjflasjdfklasdjkalsjdfkljalkdjfakljdfklasjdfklajsdfksaldjfaklsdjf你好";
}

-(void)didClickBtn{
    self.label.text = [NSString stringWithFormat:@"你好+%@",self.label.text];
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
