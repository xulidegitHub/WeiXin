//
//  XLNetworkModel.m
//  Pods
//
//  Created by 徐丽 on 2017/6/8.
//
//

#import "XLNetworkModel.h"
#import "XLNetworkModelResponse.h"
#import "XLNetworkErrorModel.h"
@implementation XLNetworkModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)impl_dateJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [XLNetworkModel impl_dateString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [XLNetworkModel impl_date:date];
    }];
}

+(NSDate*)impl_dateString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"x"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate * date = [dateFormatter dateFromString:dateString];
    if (!date) {
        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        date = [dateFormatter dateFromString:dateString];
    }
    NSLog(@"date = %@ dateString = %@",date , dateString);
    return date;
}
+(NSString*)impl_date:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"x"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateStr = [dateFormatter stringFromDate:date];
    NSLog(@"dateString = %@ date= %@",dateStr , date);
    return dateStr;
}
+ (NSValueTransformer *)impl_stringJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        }
        return [NSString stringWithFormat:@"%@", value];
    } reverseBlock:^id(NSString *data, BOOL *success, NSError *__autoreleasing *error) {
        return data;
    }];
}

+ (NSValueTransformer *)impl_numberJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }
        else if ([value isKindOfClass:[NSString class]]) {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            return [formatter numberFromString:value];
        }
        return nil;
    } reverseBlock:^id(NSNumber *data, BOOL *success, NSError *__autoreleasing *error) {
        return data;
    }];
}

+ (instancetype)modelByTest {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    NSMutableDictionary *preparedValue = [NSMutableDictionary dictionary];
    NSEnumerator *enumerator = [dictionaryValue keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id value = dictionaryValue[key];
        if (value && ![value isKindOfClass:[NSNull class]]) {
            preparedValue[key] = value;
        } else {
            NSLog(@"%@ is nil", key);
        }
    }
    
    self = [super initWithDictionary:preparedValue error:error];
    return self;
}

// 解析Model&构建出错Model
+ (nullable __kindof XLNetworkModel*)handleResponseObject:(nonnull id)responseObject modelClass:(nonnull Class)modelClass successed:(nonnull BOOL *)successed {
    
    __autoreleasing NSError *error = nil;
    *successed = NO;
    
   XLNetworkModelResponse *response = [[XLNetworkModelResponse alloc] initWithResponseObject:responseObject error:&error];
    
    if (response && [response isValid]) {
        if (response.result == NetworkResponseResultOK)
        {
            __autoreleasing NSDictionary *dictionaryValue = response.data;
            if (dictionaryValue) {
                XLNetworkModel *data = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:dictionaryValue error:&error];
                if (error) {
#if DEBUG
                    NSAssert(0, [error description]);
#endif
                    return [XLNetworkErrorModel modelResponseFormatError:error];
                } else {
                    *successed = YES;
                    return data;
                }
            } else {
                *successed = YES;
                return nil;
            }
        } else {
            if (response.code == LFDNetworkCodeTokenTimeOut) {  //token过期次处理
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                });
            }
            return [XLNetworkErrorModel modelWithCode:response.code message:response.message error:nil];
        }
    } else {
        return [XLNetworkErrorModel modelResponseFormatError:error];
    }
}

+ (nullable __kindof XLNetworkModel*)handleRequestError:(nonnull NSError *)error {
    return [XLNetworkErrorModel modelNetworkError:error];
}

@end
