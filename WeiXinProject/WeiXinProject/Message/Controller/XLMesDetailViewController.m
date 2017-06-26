//
//  XLMesDetailViewController.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "XLMesDetailViewController.h"
#import "MessageDetailCell.h"
#import "sendMesBottomView.h"
#import "UIView+Frame.h"
#import "ChatModel.h"
@interface XLMesDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITableView *MesDetailTab;
@property (nonatomic,strong)sendMesBottomView *mesBottomView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation XLMesDetailViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.MesDetailTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-60-64) style:UITableViewStylePlain];
    self.MesDetailTab.delegate = self;
    self.MesDetailTab.dataSource = self;
    self.MesDetailTab.backgroundColor = [UIColor whiteColor];
    self.MesDetailTab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.MesDetailTab];
    self.mesBottomView = [[NSBundle mainBundle] loadNibNamed:@"sendMesBottomView" owner:self   options:nil].lastObject;
    self.mesBottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width,60);
    self.mesBottomView.backgroundColor = [UIColor grayColor];
    self.mesBottomView.inputTextView.returnKeyType = UIReturnKeySend;
    self.mesBottomView.inputTextView.delegate = self;
    [self.view addSubview:self.mesBottomView];
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
  }

- (void)keyboardWillChangeFrame:(NSNotification *)note
{
     // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
       self.mesBottomView.transform = CGAffineTransformMakeTranslation(0, transformY);
        self.MesDetailTab.height = CGRectGetMinY(self.mesBottomView.frame);

        
     }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dataArray.count==0) {
        return 0;
    }else{
     return 1;
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[MessageDetailCell alloc] init];
    }
    ChatModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 4) {
        [cell yuyinView:20 from:NO withIndexRow:4 withPosition:20];
    }if (indexPath.row ==3) {
        [cell bubbleViewWithText:(NSString*)model.chatContent andfrom:NO andPosition:0 andTextFontSize:18 andIconImage:@"icon0"];
}else{
        [cell bubbleViewWithText:(NSString*)model.chatContent andfrom:YES andPosition:0 andTextFontSize:18 andIconImage:@"icon0"];

    }

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MessageDetailCell cellHeightWithChatModel:self.dataArray[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.mesBottomView.inputTextView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        ChatModel *chatModel = [[ChatModel alloc] init];
        chatModel.chatContent =textView.text;
        [self.dataArray addObject:chatModel];
        [self.MesDetailTab reloadData];
        [self.MesDetailTab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        textView.text = nil;
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;

}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.dataArray.count>1) {
        [self.MesDetailTab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
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
