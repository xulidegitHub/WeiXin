//
//  LFDNetworkSampleModel.h
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/26.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

/*
 说明：
 1、对于JSON字段同Model字段不对应的情况需要提供JSONKeyPathsByPropertyKey：
   a、映射关系：key为Model字段、value为JSON字段。
   b、需要包含所有映射关系在内。
 2、对于JSON字段值不能直接赋给Model成员的情况需要提供相应的XXXJSONTransformer转换器函数。
   a、其中XXX为Model成员名称。
 3、MTLJSONAdapter执行JSON到Model的转换过程：
   a、通过JSONKeyPathsByPropertyKey来替换JSON Dictionary字段名，使之同Model能够对应上。
   b、通过initWithDictionary（间接调用KVC）来进行Model成员变量的赋值。
 */

#import "XLNetworkModel.h"

@interface XLNetworkSampleModel : XLNetworkModel

@property (nonatomic, readonly, copy) NSString *bankCardNo;
@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *telephone;
@property (nonatomic, readonly, copy) NSString *bankCardType;
@property (nonatomic, readonly, copy) NSString *idCard;
@property (nonatomic, readonly, copy) NSString *bankName;
@property (nonatomic, readonly, copy) NSString *letvUserId;

+(instancetype)modelByTest;

@end

@interface LFDGHUser : XLNetworkModel

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSDate *createdAt;

@property (nonatomic, readonly, assign, getter = isMeUser) BOOL meUser;

@end

typedef enum : NSUInteger {
    GHIssueStateOpen,
    GHIssueStateClosed
} LFDGHIssueState;

@interface LFDGHIssue : XLNetworkModel

@property (nonatomic, readonly, copy) NSURL *URL;
@property (nonatomic, readonly, copy) NSURL *HTMLURL;
@property (nonatomic, readonly, copy) NSNumber *number;
@property (nonatomic, readonly, assign) LFDGHIssueState state;
@property (nonatomic, readonly, copy) NSString *reporterLogin;
@property (nonatomic, readonly, strong) LFDGHUser *assignee;
@property (nonatomic, readonly, copy) NSArray<LFDGHUser *> *users;
@property (nonatomic, readonly, copy) NSDate *updatedAt;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@property (nonatomic, readonly, copy) NSDate *retrievedAt;

+ (instancetype)modelByTest;

@end
