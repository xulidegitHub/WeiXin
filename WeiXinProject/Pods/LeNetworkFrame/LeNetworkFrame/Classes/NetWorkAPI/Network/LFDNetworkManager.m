
//  LFDNetworkManager.m
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDNetworkManager.h"
#import "LFDNetworkSampleModel.h"
#import "NSURLSessionTask+LFDParam.h"
#import "AFHTTPSessionManager.h"
#import "NSString+NetWork.h"
#import "LFDNetWorkConst.h"
@interface LFDNetworkManager ()

@end

@implementation LFDNetworkManager
//获取AFHTTPSessionManager 单例对象
+ (AFHTTPSessionManager*) shareManger{
   static AFHTTPSessionManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:[LFDNetworkManager userAgentString] forHTTPHeaderField:@"User-Agent"];
        [LFDNetworkManager configParamOnSerializer:manager.requestSerializer];
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        manager.requestSerializer.timeoutInterval = 20;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        NSMutableSet *newAcceptTypesSet = [manager.responseSerializer.acceptableContentTypes mutableCopy];
        [newAcceptTypesSet addObject:@"text/plain"];
        manager.responseSerializer.acceptableContentTypes = newAcceptTypesSet;
    });
    return manager;
}
#pragma mark- 添加头部参数
+ (void)configParamOnSerializer:(AFHTTPRequestSerializer *)serializer {
    NSMutableDictionary *dic = [@{} mutableCopy];
//    if ([LFDUserInfoCenter share].isUserLogin) {
//        dic[@"token"] = [LFDUserInfoCenter share].token ? : @"";
//        dic[@"uid"] = [LFDUserInfoCenter share].userModel.user.uid;
//    }
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < dic.allKeys.count; i++) {
        NSString *key = dic.allKeys[i];
        [mustr appendFormat:@"%@=%@", key, dic[key]];
        if (i != dic.allKeys.count - 1) {
            [mustr appendString:@"&"];
        }
    }
    [serializer setValue:mustr forHTTPHeaderField:@"Extensions"];
}

+ (void)configCookiesOnSerializer:(AFHTTPRequestSerializer *)serializer{
    NSMutableDictionary *dictSSO_TK = [NSMutableDictionary dictionary];
    [dictSSO_TK setValue:@"sso_tk" forKey:NSHTTPCookieName];
//    [dictSSO_TK setValue:[LFDUserInfoCenter share].token ? : @"" forKey:NSHTTPCookieValue];
//    [dictSSO_TK setValue:LFD_SERVERAPI_BASE_URL forKey:NSHTTPCookieDomain];
    [dictSSO_TK setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieSSO_TK = [NSHTTPCookie cookieWithProperties:dictSSO_TK];
    NSArray *arrCookies = [NSArray arrayWithObjects:cookieSSO_TK,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [serializer setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
}


+ (NSString *)makeAppKey:(NSDictionary *)parameters
{
    if (!parameters || !parameters.count)
        return nil;
    
    /*
     sign生成：按key自然排序的顺序，所有value拼接在一起，做SHA-512加密
     */
    NSArray *arrayKeys = [parameters allKeys];
    NSArray *sortedKeys = [arrayKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSComparisonResult result = [(NSString *)obj1 compare:(NSString *)obj2];
        
        return result;
    }];
    
    NSMutableString *signValue = [NSMutableString string];
    for (int i = 0; i < sortedKeys.count; i++)
    {
        [signValue appendFormat:@"%@", parameters[sortedKeys[i]]];
    }
    
    return [signValue sha1];
}

+ (NSDictionary *)prepareParameter:(NSDictionary *)parameters sign:(BOOL)sign;
{
    NSMutableDictionary *newParameters = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    
    if (sign && ![parameters objectForKey:@"appKey"])
    {
        NSString *appKey = [LFDNetworkManager makeAppKey:parameters];
        newParameters[@"appKey"] = appKey;
    }
    
    return [newParameters copy];
}

+ (NSString *)userAgentString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return [NSString stringWithFormat:@"%@/%@", APP_REPORT_NAME, version];
}

+ (NSString *)makeRestUrl:(NSString *)url parameters:(NSArray *)parameters
{
    NSMutableString *restUrl = [url mutableCopy];
    for (int i = 0; i < parameters.count; i++)
    {
        NSString *temp = nil;
        if ([parameters[i] isKindOfClass:[NSString class]]) {
            temp = parameters[i];
        } else if ([parameters[i] isKindOfClass:[NSNumber class]]) {
            temp = [parameters[i] stringValue];
        } else {
            temp = [NSString stringWithFormat:@"%@", parameters[i]];
        }
        NSMutableCharacterSet *allowSet = [[NSCharacterSet URLPathAllowedCharacterSet] mutableCopy];
        [allowSet removeCharactersInString:@"/"];
        temp = [temp stringByAddingPercentEncodingWithAllowedCharacters:allowSet];
        
        [restUrl appendString:temp];
        if (i != parameters.count - 1)
        {
            [restUrl appendString:@"/"];
        }
    }
    
    return [restUrl copy];
}

+ (void)handleResponseObject:(id)responseObject modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    NSLog(@"response object = %@", responseObject);
    
    if ([modelClass respondsToSelector:@selector(handleResponseObject:modelClass:successed:)]) {
        BOOL success = NO;
        LFDNetworkModel *model = [modelClass handleResponseObject:responseObject modelClass:modelClass successed:&success];
        if (complete) {
            complete(success, model);
        }
    } else {
        NSLog(@"网络层Model解析错误，Model类没有对应的解析器");
        if (complete) {
            complete(NO, nil);
        }
    }
}

// 仅网络层错误会到此
+ (void)handleRequestError:(NSError *)error modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    if ([modelClass respondsToSelector:@selector(handleRequestError:)]) {
        LFDNetworkModel *model = [modelClass handleRequestError:error];
        if (model && complete) {
            complete(NO, model);
        }
    } else {
        NSLog(@"网络层Model解析错误，Model类没有对应的解析器");
        if (complete) {
            complete(NO, nil);
        }
    }
}

+ (NSURLSessionTask *)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{

    
    AFHTTPSessionManager *manager = [LFDNetworkManager shareManger];
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [LFDNetworkManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }
    
//    //转让模块 需要传递cookie信息做白名单校验
//    if ([url hasPrefix:@"transfer/"] || [url containsString:@"transferPage"]) {
//        [LFDNetworkManager configCookiesOnSerializer:manager.requestSerializer];
//    }
    
    NSDictionary *newParameters = [LFDNetworkManager prepareParameter:parameters sign:sign];
    NSLog(@"fullUrl = %@ -- %@",fullUrl,newParameters);

    NSURLSessionTask* task =[manager POST:fullUrl parameters:newParameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       // [LFDStatistic lfd_requestDurationWithUrl:fullUrl dur:[task lfd_duration]];
        [self handleResponseObject:responseObject modelClass:modelClass complete:complete];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
        [self handleRequestError:error modelClass:modelClass complete:complete];
    }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    [task markDate];
    return task;
}

+ (NSURLSessionTask *)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    return [self getRequestWithUrl:url parameters:parameters sign:sign modelClass:modelClass filterBlock:nil complete:complete];
}


//get请求加上数据过滤处理的回调
+ (NSURLSessionTask *)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
                                   sign:(BOOL)sign modelClass:(Class)modelClass filterBlock:(id (^)(id object))filterBlock complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete {

    
    AFHTTPSessionManager *manager = [LFDNetworkManager shareManger];
   
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [LFDNetworkManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }
    
    //转让模块 需要传递cookie信息做白名单校验
    if ([url hasPrefix:@"transfer/"] || [url containsString:@"transferPage"]) {
        [LFDNetworkManager configCookiesOnSerializer:manager.requestSerializer];
    }

    NSDictionary *newParameters = [LFDNetworkManager prepareParameter:parameters sign:sign];
    
    NSLog(@"fullUrl = %@   \n%@",fullUrl, newParameters);
    NSURLSessionTask* task = [manager GET:fullUrl parameters:newParameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (filterBlock) {
            responseObject = filterBlock(responseObject);
        }
        [self handleResponseObject:responseObject modelClass:modelClass complete:complete];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
        [self handleRequestError:error modelClass:modelClass complete:complete];
    }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    [task markDate];
    return task;
}

+ (void)testHttp2 {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    
    NSString *fullUrl = @"https://http2.akamai.com";

    [manager GET:fullUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([responseString containsString:@"You are using HTTP/2 right now!"]) {
            NSLog(@"Support Http 2.0!!!!!");
        } else {
            NSLog(@"Not support Http 2.0!!!!!");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

+ (NSURLSessionTask *)restGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{

    
    NSString *restUrl = [LFDNetworkManager makeRestUrl:url parameters:parameters];
    
    NSLog(@"%@",restUrl);
    NSURLSessionTask* task = [LFDNetworkManager getRequestWithUrl:restUrl parameters:nil sign:NO modelClass:modelClass complete:complete];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}


+ (NSURLSessionTask *)uploadFileToUrl:(NSString *)url parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *uploadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *filePath, NSError *error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    if (bool_auth_ssl_certificate) {
        manager.securityPolicy = [LFDNetworkManager loadPolicyFiles];
    }

    [serializer setValue:[LFDNetworkManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [LFDNetworkManager configParamOnSerializer:serializer];
     NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&serializationError];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:localFile] progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (complete)
        {
            complete(error?NO:YES, url, localFile, error);
        }
    }];
    
    [uploadTask resume];
    [uploadTask markDate];
    return uploadTask;
}

+ (NSURLSessionTask *)uploadFileToUrl:(NSString *)url parameters:(NSDictionary *)parameters bodyData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *filePath, NSError *error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    if (bool_auth_ssl_certificate) {
        manager.securityPolicy = [LFDNetworkManager loadPolicyFiles];
    }

    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:[LFDNetworkManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [LFDNetworkManager configParamOnSerializer:serializer];
     NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&serializationError];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = NSUTF8StringEncoding;
    NSMutableSet *newAcceptTypesSet = [responseSerializer.acceptableContentTypes mutableCopy];
    [newAcceptTypesSet addObject:@"text/html"];
    responseSerializer.acceptableContentTypes = newAcceptTypesSet;
    manager.responseSerializer = responseSerializer;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:bodyData progress:progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!responseObject || error) {
            if (complete) {
                complete(NO, url, nil, error);
            }
        } else {
            NSError *parseError = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&parseError];
            if (complete)
            {
                if (dic && [dic[@"success"] boolValue]) {
                    complete(YES, url, dic[@"url"], nil);
                } else {
                    complete(NO, url, nil, parseError);
                }
            }
        }
          }];
    [uploadTask resume];
    return uploadTask;
}

//带证书认证
+ (NSURLSessionTask *)downloadFileFromUrl:(NSString *)url parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *downloadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *localFile, NSError *error))complete
{
    return [self downloadFileFromUrl:url ssl_certificate:YES parameters:parameters localPath:localFile progress:progress complete:complete];
}


//可选证书认证
+ (NSURLSessionTask *)downloadFileFromUrl:(NSString *)url ssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *downloadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *localFile, NSError *error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    if (ssl_certificate && [LFDConstant share].bool_auth_ssl_certificate) {
//        manager.securityPolicy = [LFDNetworkManager loadPolicyFiles];
//    }
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:[LFDNetworkManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [LFDNetworkManager configParamOnSerializer:serializer];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:parameters error:&serializationError];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        if (localFile)
        {
            return [NSURL fileURLWithPath:localFile];
        }
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (complete)
        {
            complete(error?NO:YES, url, [filePath path], error);
        }
        
    }];
    
    [downloadTask resume];
    [downloadTask markDate];
    return downloadTask;
}

+ (void)testResponse
{
    NSDictionary *testData1 = @{@"result": @"1",
                                @"code": @"0",
                                @"message": @"",
                                @"data": @{
                                        @"bankCardNo": @"6226000000000001",
                                        @"username": @"user name",
                                        @"telephone": @"13100000001",
                                        @"bankCardType": @"借记卡",
                                        @"idCard": @"110101200001010001",
                                        @"bankName": @"工商银行",
                                        @"letvUserId": @"10000001"
                                        }
                                };
/*
    NSDictionary *testData2 = @{@"result": @"1",
                                @"code": @"0",
                                @"message": @"",
                                };
    
    NSDictionary *testData3 = @{@"result": @"1",
                                @"code": @"0",
                                @"message": @"",
                                @"data": @"wrong data"
                                };
*/
    [LFDNetworkManager handleResponseObject:testData1 modelClass:[LFDNetworkSampleModel class] complete:^(BOOL success, LFDNetworkModel *responseObject) {

        if (success)
        {
            LFDNetworkSampleModel *model = (LFDNetworkSampleModel *)responseObject;
            NSLog(@"%@", model);
        }
    }];
}

+ (void)testUpload
{
    // need to do...
}

+ (void)testDownload
{
    [self downloadFileFromUrl:@"http://www.leeco.com/images/banner10.jpg" parameters:nil localPath:nil progress:nil complete:^(BOOL success, NSString *url, NSString *localFile, NSError *error) {
        NSLog(@"download %@ to %@ %@", url, localFile, success?@"successed":@"failed");
    }];
}

+ (void)testAnyRequestWithModelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    float delay = (float)(arc4random() % 20 + 1) / 10.0;    // 0.1-2.0 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complete)
        {
            LFDNetworkModel *model = [modelClass modelByTest];
            complete(YES, model);
        }
    });
}

+ (void)testPostRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    [LFDNetworkManager testAnyRequestWithModelClass:modelClass complete:complete];
}

+ (void)testGetRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    [LFDNetworkManager testAnyRequestWithModelClass:modelClass complete:complete];
}

+ (void)testRestGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete
{
    [LFDNetworkManager testAnyRequestWithModelClass:modelClass complete:complete];
}

//加载证书文件
+ (AFSecurityPolicy *)loadPolicyFiles {
#if DEBUGTEST
    //测试包抓包
    return [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
#else
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
#warning  -- 若需要验证证书 此处需要配置证书
//    if ([LFDSSLReload certificates].count) {
//        policy.pinnedCertificates = [LFDSSLReload certificates];
//    }
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;   
#endif
}

@end
