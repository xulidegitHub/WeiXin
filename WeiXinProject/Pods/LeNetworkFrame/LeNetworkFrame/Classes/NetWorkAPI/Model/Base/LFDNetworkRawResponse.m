//
//  LFDNetworkRawResponse.m
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDNetworkRawResponse.h"

@interface LFDNetworkRawResponse ()

@end

@implementation LFDNetworkRawResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"result": @"result",
             @"code": @"code",
             @"message": @"message",
             @"data": @"data"
             };
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%@不存在",key);
}
- (instancetype)initWithResponseObject:(id)responseObject error:(NSError **)error
{
    if (![responseObject isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }

    NSDictionary *dictionaryValue = (NSDictionary *)responseObject;
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self)
    {
        _valid = YES;
        
        if (_result == LFDNetworkResponseResultOK)
        {
            if (_data && ![_data isKindOfClass:[NSDictionary class]])
            {
                _valid = NO;
                [self setValue:nil forKey:@"data"];
            }
        }
        else
        {
            [self setValue:nil forKey:@"data"];
        }
    }
    
    return self;
}

@end
