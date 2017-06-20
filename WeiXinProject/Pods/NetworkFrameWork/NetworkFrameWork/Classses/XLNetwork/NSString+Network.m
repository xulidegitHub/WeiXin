//
//  NSString+Network.m
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import "NSString+Network.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Network)
- (NSString *)md5
{
    if (self == nil || self.length == 0)
    {
        return nil;
    }
    
    const char *cstr = self.UTF8String;
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [outputString appendFormat:@"%02x", digest[i]];
    }
    
    return outputString;
}

- (NSString *)sha1
{
    if (self == nil || self.length == 0)
    {
        return nil;
    }
    
    const char *cstr = self.UTF8String;
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [outputString appendFormat:@"%02x", digest[i]];
    }
    
    return outputString;
}

- (NSString *)sha512
{
    if (self == nil || self.length == 0)
    {
        return nil;
    }
    
    const char *cstr = self.UTF8String;
    unsigned char digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA1(cstr, (CC_LONG)strlen(cstr), digest);
    
    NSMutableString* outputString = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [outputString appendFormat:@"%02x", digest[i]];
    }
    
    return outputString;
}

- (NSString *)encode
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&amp;=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    outputStr = [outputStr stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    return outputStr;
}

- (NSString *)decode
{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                              kCFAllocatorDefault,
                                                                              (__bridge CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return outputStr;
}
@end
