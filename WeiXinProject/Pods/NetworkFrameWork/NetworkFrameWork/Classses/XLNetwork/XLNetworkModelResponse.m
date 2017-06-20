//
//  XLNetworkModelResponse.m
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import "XLNetworkModelResponse.h"
@implementation XLNetworkModelResponse

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
        
        if (_result == NetworkResponseResultOK)
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
