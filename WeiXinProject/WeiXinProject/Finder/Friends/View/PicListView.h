//
//  PicListView.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/15.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicListView : UIView
-(void)createSubViewWithsourceImageArray:(NSArray*)imageListArray;
@property (nonatomic,assign)CGFloat origionWidth;
@end
