//
//  XLNetwrokManager.m
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import "XLNetwrokManager.h"
#import "NSString+Network.h"
#import "XLNetworkHeadConst.h"
#import "XLNetworkConfig.h"
#import "XLNetworkSampleModel.h"
@implementation XLNetwrokManager
#pragma mark -创建管理对象单例
+ (AFHTTPSessionManager*) shareManger{
    static AFHTTPSessionManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:[XLNetwrokManager userAgentString] forHTTPHeaderField:@"User-Agent"];
        [XLNetwrokManager configParamOnSerializer:manager.requestSerializer];
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
#pragma mark--添加cookie
+ (void)configCookiesOnSerializer:(AFHTTPRequestSerializer *)serializer{
    NSMutableDictionary *dictSSO_TK = [NSMutableDictionary dictionary];
    [dictSSO_TK setValue:@"sso_tk" forKey:NSHTTPCookieName];
    [dictSSO_TK setValue:@"/" forKey:NSHTTPCookiePath];
    NSHTTPCookie *cookieSSO_TK = [NSHTTPCookie cookieWithProperties:dictSSO_TK];
    NSArray *arrCookies = [NSArray arrayWithObjects:cookieSSO_TK,nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [serializer setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
}
#pragma mark - 生成APPKEY
+ (NSString *_Nullable)makeAppKey:(NSDictionary *_Nullable)parameters
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

#pragma mark - 生成要传递的参数
+ (NSDictionary *)prepareParameter:(NSDictionary *)parameters sign:(BOOL)sign
{
    NSMutableDictionary *newParameters = parameters ? [parameters mutableCopy] : [NSMutableDictionary dictionary];
    //当sign传入yes，appkey值不存在此时会生成appkey
    if (sign && ![parameters objectForKey:@"appKey"])
    {
        NSString *appKey = [XLNetwrokManager makeAppKey:parameters];
        newParameters[@"appKey"] = appKey;
    }
    return [newParameters copy];
}
#pragma mark - 生成userAgentString
+ (NSString *)userAgentString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return [NSString stringWithFormat:@"%@/%@", APP_REPORT_NAME, version];
}
#pragma mark--生成resturl
+ (NSString *_Nullable)makeRestUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters
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
#pragma mark--处理response
+ (void)handleResponseObject:(id)responseObject modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    NSLog(@"response object = %@", responseObject);
    if ([modelClass respondsToSelector:@selector(handleResponseObject:modelClass:successed:)]) {
        BOOL success = NO;
        XLNetworkModel *model = [modelClass handleResponseObject:responseObject modelClass:modelClass successed:&success];
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
#pragma mark --处理网络层错误信息
+ (void)handleRequestError:(NSError *)error modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    if ([modelClass respondsToSelector:@selector(handleRequestError:)]) {
        XLNetworkModel *model = [modelClass handleRequestError:error];
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
#pragma post请求，带转模型
+ (NSURLSessionTask *_Nullable)postRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
{
    AFHTTPSessionManager *manager = [XLNetwrokManager shareManger];
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }

    NSDictionary *newParameters = [XLNetwrokManager prepareParameter:parameters sign:sign];
    NSLog(@"fullUrl = %@ -- %@",fullUrl,newParameters);
    NSURLSessionDataTask* task = [manager POST:fullUrl parameters:newParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          [self handleResponseObject:responseObject modelClass:modelClass complete:complete];
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"error = %@",error);
       [self handleRequestError:error modelClass:modelClass complete:complete];

   }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}
#pragma mark --没有转模型的post请求
+(NSURLSessionTask *_Nullable)postRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign complete:(void (^_Nullable)(BOOL success, id _Nonnull responseObject))complete{
    AFHTTPSessionManager *manager = [XLNetwrokManager shareManger];
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }
    
    NSDictionary *newParameters = [XLNetwrokManager prepareParameter:parameters sign:sign];
    NSLog(@"fullUrl = %@ -- %@",fullUrl,newParameters);
    NSURLSessionDataTask *task = [manager POST:fullUrl parameters:newParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (complete) {
            complete(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(NO,error);
        }
    }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}

#pragma mark -带转模型的get请求
+ (NSURLSessionTask *_Nullable)getRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete
{
    return [self getRequestWithUrl:url parameters:parameters sign:sign modelClass:modelClass filterBlock:nil complete:complete];
}
#pragma mark -带转模型的带过滤参数的get请求
+ (NSURLSessionTask *_Nullable)getRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters
                                            sign:(BOOL)sign modelClass:(Class _Nullable )modelClass filterBlock:(id _Nullable (^_Nullable)(id _Nullable object))filterBlock complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete {
    
    
    AFHTTPSessionManager *manager = [XLNetwrokManager shareManger];
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }
    NSDictionary *newParameters = [XLNetwrokManager prepareParameter:parameters sign:sign];
    
    NSLog(@"fullUrl = %@   \n%@",fullUrl, newParameters);
    NSURLSessionDataTask* task = [manager GET:fullUrl parameters:newParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (filterBlock) {
            responseObject = filterBlock(responseObject);
        }
        [self handleResponseObject:responseObject modelClass:modelClass complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        [self handleRequestError:error modelClass:modelClass complete:complete];

    }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}
#pragma mark -不带转模型的get请求
+(NSURLSessionTask *_Nullable)getRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign  complete:(void (^_Nullable)(BOOL success,id  _Nonnull responseObject))complete{
    return [self getRequestNotransferWithUrl:url parameters:parameters sign:sign filterBlock:nil complete:complete];
}
#pragma mark -不带转模型的带过滤参数的get请求
+ (NSURLSessionTask *_Nullable)getRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign  filterBlock:(id _Nullable (^_Nullable)(id _Nullable object))filterBlock complete:(void (^_Nullable)(BOOL success, id  _Nonnull responseObject))complete{
    AFHTTPSessionManager *manager = [XLNetwrokManager shareManger];
    NSString *fullUrl = url;
    if (![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        if (bool_auth_ssl_certificate) {
            manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
            fullUrl = [NSString stringWithFormat:@"https://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        } else {
            fullUrl = [NSString stringWithFormat:@"http://%@/%@", LFD_SERVERAPI_BASE_URL, url];
        }
    }
    NSDictionary *newParameters = [XLNetwrokManager prepareParameter:parameters sign:sign];
    NSLog(@"fullUrl = %@   \n%@",fullUrl, newParameters);
    NSURLSessionDataTask* task = [manager GET:fullUrl parameters:newParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (filterBlock) {
            responseObject = filterBlock(responseObject);
        }
        if (complete) {
            complete(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
        if (complete) {
            complete(NO,error);
        }
    }];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}
#pragma mark -rest方式的get请求
+ (NSURLSessionTask *)restGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    NSString *restUrl = [XLNetwrokManager makeRestUrl:url parameters:parameters];
    NSLog(@"%@",restUrl);
    NSURLSessionTask* task = [XLNetwrokManager getRequestWithUrl:restUrl parameters:nil sign:NO modelClass:modelClass complete:complete];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;
}
#pragma mark -rest方式的get请求，不带转模型的
+ (NSURLSessionTask *_Nullable)restGetRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete{
    NSString *restUrl = [XLNetwrokManager makeRestUrl:url parameters:parameters];
    NSLog(@"%@",restUrl);
    NSURLSessionTask* task = [XLNetwrokManager getRequestNotransferWithUrl:restUrl parameters:nil sign:NO complete:complete];
    NSLog(@"task.currentRequest.URL = %@",task.currentRequest.URL);
    return task;

}
#pragma mark--上传本地文件
+ (NSURLSessionTask *_Nullable)uploadFileToUrl:(NSString *_Nullable)url andssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *_Nullable)parameters localPath:(NSString *_Nullable)localFile progress:(void (^_Nullable)(NSProgress * _Nullable uploadProgress))progress complete:(void (^_Nullable)(BOOL success, NSString * _Nullable url, NSString * _Nullable filePath, NSError * _Nullable error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    if (ssl_certificate && bool_auth_ssl_certificate) {
        manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
    }
    
    [serializer setValue:[XLNetwrokManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [XLNetwrokManager configParamOnSerializer:serializer];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&serializationError];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:[NSURL fileURLWithPath:localFile] progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (complete)
        {
            complete(error?NO:YES, url, localFile, error);
        }

    }];
    
    [uploadTask resume];
    return uploadTask;
}
#pragma mark--上传文件
+ (NSURLSessionTask *_Nullable)uploadFileToUrl:(NSString *_Nullable)url andssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *_Nullable)parameters bodyData:(NSData *_Nullable)bodyData progress:(void (^_Nullable)(NSProgress * _Nullable uploadProgress))progress complete:(void (^_Nullable)(BOOL success, NSString * _Nullable url, NSString * _Nullable filePath, NSError * _Nullable error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    if (ssl_certificate&&bool_auth_ssl_certificate) {
        manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
    }
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:[XLNetwrokManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [XLNetwrokManager configParamOnSerializer:serializer];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:parameters error:&serializationError];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = NSUTF8StringEncoding;
    NSMutableSet *newAcceptTypesSet = [responseSerializer.acceptableContentTypes mutableCopy];
    [newAcceptTypesSet addObject:@"text/html"];
    responseSerializer.acceptableContentTypes = newAcceptTypesSet;
    manager.responseSerializer = responseSerializer;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromData:bodyData progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
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
#pragma mark-下载证书，带可选证书认证
+ (NSURLSessionTask *)downloadFileFromUrl:(NSString *)url ssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *downloadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *localFile, NSError *error))complete
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    if (ssl_certificate && bool_auth_ssl_certificate) {
        manager.securityPolicy = [XLNetwrokManager loadPolicyFiles];
    }
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    [serializer setValue:[XLNetwrokManager userAgentString] forHTTPHeaderField:@"User-Agent"];
    [XLNetwrokManager configParamOnSerializer:serializer];
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:parameters error:&serializationError];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
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
    return downloadTask;
}
#pragma --mark 加载证书
+ (AFSecurityPolicy *)loadPolicyFiles{
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    NSArray* arrFileName = [XLNetworkConfig shareConfig].fileNameArr;
    if (arrFileName.count > 0) {
        NSMutableArray* setCertificates = [NSMutableArray array];
        for (NSString* strFile in arrFileName) {
            NSString *pemPath = [[NSBundle mainBundle] pathForResource:strFile ofType:@"der"];
            NSData *pemData = [NSData dataWithContentsOfFile:pemPath];
            if (pemData) {
                [setCertificates addObject:pemData];
            }
        }
        policy.pinnedCertificates = setCertificates;
    }
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    return policy;
}

#pragma mark--测试服务器是否支持http2.0
+ (void)testHttp2 {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
    
    NSString *fullUrl = @"https://http2.akamai.com";
    [manager GET:fullUrl parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([responseString containsString:@"You are using HTTP/2 right now!"]) {
            NSLog(@"Support Http 2.0!!!!!");
        } else {
            NSLog(@"Not support Http 2.0!!!!!");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
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
   
     NSDictionary *testData2 = @{@"result": @"1",
     @"code": @"0",
     @"message": @"",
     };
    
    NSDictionary *testData3 = @{@"result": @"1",
     @"code": @"0",
     @"message": @"",
     @"data": @"wrong data"
     };
    
    [XLNetwrokManager handleResponseObject:testData1 modelClass:[XLNetworkSampleModel class] complete:^(BOOL success, XLNetworkModel *responseObject) {
        
        if (success)
        {
            XLNetworkSampleModel *model = (XLNetworkSampleModel *)responseObject;
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
    [self downloadFileFromUrl:@"http://www.leeco.com/images/banner10.jpg" ssl_certificate:NO parameters:nil localPath:nil progress:nil complete:^(BOOL success, NSString *url, NSString *localFile, NSError *error) {
        NSLog(@"download %@ to %@ %@", url, localFile, success?@"successed":@"failed");
    }];
}

+ (void)testAnyRequestWithModelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    float delay = (float)(arc4random() % 20 + 1) / 10.0;    // 0.1-2.0 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (complete)
        {
            XLNetworkModel *model = [modelClass modelByTest];
            complete(YES, model);
        }
    });
}

+ (void)testPostRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    [XLNetwrokManager testAnyRequestWithModelClass:modelClass complete:complete];
}

+ (void)testGetRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    [XLNetwrokManager testAnyRequestWithModelClass:modelClass complete:complete];
}

+ (void)testRestGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, XLNetworkModel *responseObject))complete
{
    [XLNetwrokManager testAnyRequestWithModelClass:modelClass complete:complete];
}


@end
