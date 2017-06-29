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
#import "EmojeInputView.h"
#import "CorderManager.h"
@interface XLMesDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (nonatomic,strong)UITableView *MesDetailTab;
@property (nonatomic,strong)sendMesBottomView *mesBottomView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong) EmojeInputView *faceView;
@property (nonatomic,assign) BOOL isSelectedEmoj;
@property (nonatomic,assign) BOOL isChangeKey;
@property (nonatomic,assign) float keyBoardHeight;
@property (nonatomic,strong) NSMutableArray *emojDataArray;
@property (nonatomic,strong) CorderManager *recorderManager;
@end

@implementation XLMesDetailViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)emojDataArray{
    if (!_emojDataArray) {
        _emojDataArray = [NSMutableArray array];
    }

    for (int i=0; i<105; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"OriginalExpression.bundle/Expression_%d",i+1]];
        [_emojDataArray addObject:image];
    }
    return _emojDataArray;
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
    __weak typeof(self) weakSelf = self;
    self.mesBottomView.clickEmojBtnBLock = ^(NSInteger index) {
        if (index==1001) {
        [weakSelf.mesBottomView.inputTextView resignFirstResponder];
        weakSelf.mesBottomView.inputTextView.text = @"按住说话";
        weakSelf.mesBottomView.inputTextView.textAlignment = NSTextAlignmentCenter;
        weakSelf.mesBottomView.inputTextView.editable = NO;
//        weakSelf.mesBottomView.inputTextView.userInteractionEnabled = YES;
//        UIGestureRecognizer  *lognPress = [[UIGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(didClickInputView)];
//        [weakSelf.mesBottomView.inputTextView addGestureRecognizer:lognPress];
            [weakSelf didClickRecorderBtn];
            
        }else if(index == 1002){
            weakSelf.isChangeKey = YES;
            weakSelf.isSelectedEmoj = !weakSelf.isSelectedEmoj;
            if (weakSelf.isSelectedEmoj) {
                [weakSelf.mesBottomView.inputTextView resignFirstResponder];
            }else{
                [weakSelf.mesBottomView.inputTextView becomeFirstResponder];
            }

        }else if(index == 1003){
            [weakSelf didClickInputView];
        }
    };
    [self.view addSubview:self.mesBottomView];
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
  }

-(void)didClickInputView{
    [self.recorderManager stopRecorder];
}

-(void)didClickRecorderBtn{
    
    self.recorderManager = [[CorderManager alloc]init];
    [self.recorderManager recorderWithsavePath:@"/Users/xuxuli/Desktop/luyin"];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    //这样就拿到了键盘的位置大小信息frame，然后根据frame进行高度处理之类的信息
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyBoardHeight = frame.size.height;
}
/**
 *  键盘将要隐藏
 *
 *  @param notification 通知
 */
-(void)keyboardWillHidden:(NSNotification *)notification
{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

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
        if (_isChangeKey) {
            if (self.isSelectedEmoj) {
                self.faceView = [[EmojeInputView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-250, [UIScreen mainScreen].bounds.size.width, 250)];
                [self.view addSubview:self.faceView];
                [self.faceView reloadDataWithArray:self.emojDataArray];
                self.mesBottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.faceView.height-self.mesBottomView.height, self.mesBottomView.width, self.mesBottomView.height);
            }else{
                [self.faceView removeFromSuperview];
                self.mesBottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.keyBoardHeight-self.mesBottomView.height, self.mesBottomView.width, self.mesBottomView.height);
            }
        }else{
            if (self.faceView) {
                [self.faceView removeFromSuperview];
            }
            self.mesBottomView.transform = CGAffineTransformMakeTranslation(0, transformY);
            self.MesDetailTab.height = CGRectGetMinY(self.mesBottomView.frame);
        }
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
       self.isChangeKey = NO;
       return YES;
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
