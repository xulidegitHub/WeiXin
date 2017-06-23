


//
//  MessageDetailCell.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/21.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "MessageDetailCell.h"
#import "NSString+Common.h"
#import "UIView+Frame.h"
#define iconWidth 40
#define iconHeight iconWidth
@interface MessageDetailCell()
@property (nonatomic,assign)CGFloat fontSize;
@end
@implementation MessageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bubbleViewWithText:(NSString*)text andfrom:(BOOL)fromSelf andPosition:(float)position andTextFontSize:(CGFloat)fontSize andIconImage:(NSString*)iconImage{
    self.fontSize = fontSize;
    UIView *returnVIew = [[UIView alloc] initWithFrame:CGRectZero];
    returnVIew.backgroundColor = [UIColor blueColor];
    returnVIew.width = [UIScreen mainScreen].bounds.size.width-80;
      UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImage]];
    if (fromSelf) {
        iconImageView.frame = CGRectMake(returnVIew.width-10-iconWidth, 10, iconWidth, iconHeight);
    }else{
        iconImageView.frame = CGRectMake(10, 10, iconHeight, iconHeight);
    }
    [returnVIew addSubview:iconImageView];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [text sizeWithFontSize:fontSize maxSize:CGSizeMake(returnVIew.width-iconWidth-10-10-30, [UIScreen mainScreen].bounds.size.height-100)];
    UIImage *image = nil;
    if (fromSelf) {
      image = [UIImage imageNamed:@"SenderVoiceNodeBack"];
    }else{
        image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
    }
    UIImageView *bubleImageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)]];
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?CGRectGetMinX(iconImageView.frame)-size.width-30:CGRectGetMaxX(iconImageView.frame)+25,20, size.width, size.height)];
    bubbleText.backgroundColor = [UIColor redColor];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    bubleImageView.frame = CGRectMake(fromSelf?CGRectGetMinX(iconImageView.frame)-size.width-40:CGRectGetMaxX(iconImageView.frame)+10,10,size.width+30, size.height+30);
    returnVIew.frame = CGRectMake(fromSelf?80:0, 0, returnVIew.width, bubleImageView.height+20);
    [returnVIew addSubview:bubleImageView];
    [returnVIew addSubview:bubbleText];
    [self.contentView addSubview:returnVIew];
}

//泡泡语音
- (void)yuyinView:(NSInteger)logntime from:(BOOL)fromSelf withIndexRow:(NSInteger)indexRow  withPosition:(int)position{
    
    //根据语音长度
    int yuyinwidth = 66+fromSelf;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexRow;
    if(fromSelf)
        button.frame =CGRectMake(320-position-yuyinwidth, 10, yuyinwidth, 54);
    else
        button.frame =CGRectMake(position, 10, yuyinwidth, 54);
    
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = -10;
    imageInsert.left = fromSelf?button.frame.size.width/3:-button.frame.size.width/3;
    button.imageEdgeInsets = imageInsert;
    
    [button setImage:[UIImage imageNamed:fromSelf?@"SenderVoiceNodePlaying":@"ReceiverVoiceNodePlaying"] forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"SenderVoiceNodeDownloading":@"ReceiverVoiceNodeDownloading"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fromSelf?-30:button.frame.size.width, 0, 30, button.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%ld''",(long)logntime];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [button addSubview:label];
    [self addSubview:button];
}

+(CGFloat)cellHeightWithChatModel:(ChatModel*)chatModel{
     CGSize size = [chatModel.chatContent sizeWithFontSize:18 maxSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-80-iconWidth-10-10-30, [UIScreen mainScreen].bounds.size.height-100)];
    return size.height+60;
    
}

@end
