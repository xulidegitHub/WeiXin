//
//  LFDNetworkSampleModel.m
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/26.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDNetworkSampleModel.h"

@implementation LFDNetworkSampleModel

+ (instancetype)modelByTest
{
    NSDictionary *testData = @{
                               @"bankCardNo": @"6226000000000001",
                               @"username": @"user name",
                               @"telephone": @"13100000001",
                               @"bankCardType": @"借记卡",
                               @"idCard": @"110101200001010001",
                               @"bankName": @"工商银行",
                               @"letvUserId": @"10000001"
                               };
    __autoreleasing NSError *error = nil;
    LFDNetworkSampleModel *model = [MTLJSONAdapter modelOfClass:LFDNetworkSampleModel.class fromJSONDictionary:testData error:&error];
    
    return model;
}

@end

@implementation LFDGHUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    /*return @{
             @"name": @"name",
             @"createdAt": @"created_at"
             };*/
    NSMutableDictionary *result = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [result addEntriesFromDictionary:@{
                                       @"createdAt": @"created_at"
                                       }];
    return result;
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [super impl_dateJSONTransformer];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

@end

@implementation LFDGHIssue

+ (instancetype)modelByTest
{
    NSDictionary *testData = @{
                               @"url": @"http://www.leeco.com",
                               @"html_url": @"http://www.leeco.com/index.html",
                               @"number": @18123456789012345678UL,
                               @"state": @"closed",
                               @"reporterLogin": @"user.login",
                               @"assignee": @{
                                       @"name": @"xyz abc",
                                       @"created_at": @"2010-11-11T23:56:24Z"
                                       },
                               @"users": @[@{
                                               @"name": @"user1",
                                               @"created_at": @"2010-11-11T23:56:01Z"
                                               },
                                           @{
                                               @"name": @"用户2",
                                               @"created_at": @"2010-11-11T23:56:02Z"
                                               },
                                           @{
                                               @"name": @"asdfasdf",
                                               @"created_at": @"2010-11-11T23:56:03Z"
                                               }
                                           ],
                               @"updated_at": @"1990-09-01T13:45:01Z"
                               };
    __autoreleasing NSError *error = nil;
    LFDGHIssue *model = [MTLJSONAdapter modelOfClass:LFDGHIssue.class fromJSONDictionary:testData error:&error];
    
    return model;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    /*return @{
             @"URL": @"url",
             @"HTMLURL": @"html_url",
             @"number": @"number",
             @"state": @"state",
             @"reporterLogin": @"user.login",
             @"assignee": @"assignee",
             @"users": @"users",
             @"updatedAt": @"updated_at"
             };*/
    
    NSMutableDictionary *result = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    [result addEntriesFromDictionary:@{
                                       @"URL": @"url",
                                       @"HTMLURL": @"html_url",
                                       @"reporterLogin": @"user.login",
                                       @"updatedAt": @"updated_at"
                                       }];
    return result;
}
/*
+ (NSValueTransformer *)URLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)HTMLURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
*/
+ (NSValueTransformer *)stateJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"open": @(GHIssueStateOpen),
                                                                           @"closed": @(GHIssueStateClosed)
                                                                           }];
}
/*
+ (NSValueTransformer *)assigneeJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:LFDGHUser.class];
}
*/

+ (NSValueTransformer *)usersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:LFDGHUser.class];
}

+ (NSValueTransformer *)updatedAtJSONTransformer
{
    return [super impl_dateJSONTransformer];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
    _retrievedAt = [NSDate date];
    
    return self;
}

@end
