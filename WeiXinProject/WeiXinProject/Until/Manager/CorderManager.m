//
//  CorderManager.m
//  WeiXinProject
//
//  Created by 徐丽 on 2017/6/28.
//  Copyright © 2017年 徐丽. All rights reserved.
//

#import "CorderManager.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
@interface CorderManager()
@property (nonatomic,strong)AVAudioRecorder *audioRecorder;
@end
@implementation CorderManager
-(void)recorderWithsavePath:(NSString*)savePath{
    NSError *error = nil;
    NSDate *date=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *datefloder= [dateformatter stringFromDate:date];
    NSString *dateaudioPath=[NSString stringWithFormat:@"%@/",datefloder];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    //指向文件目录
    NSString *documentsDirectory= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    if (![fileMgr fileExistsAtPath:documentsDirectory]) {
        [fileMgr createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey, [NSNumber numberWithFloat:22050.0], AVSampleRateKey, [NSNumber numberWithInt:1], AVNumberOfChannelsKey, nil];
  self.audioRecorder=[[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:documentsDirectory isDirectory:YES] settings:settings error:&error];
    if (self.audioRecorder) {
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder prepareToRecord];
        [self.audioRecorder record];
        //启动定时器,为了更新电平
    }else{

      }
    
}



-(void)stopRecorder{
    [self.audioRecorder stop];
}
@end
