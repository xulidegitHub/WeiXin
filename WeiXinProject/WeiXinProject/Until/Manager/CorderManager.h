//
//  CorderManager.h
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/28.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CorderManager : NSObject
-(void)recorderWithsavePath:(NSString*)savePath;
-(void)stopRecorder;
@end
