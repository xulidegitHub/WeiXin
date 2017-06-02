//
//  LFDNetworkManager.h
//  LFDistributionApp
//
//  Created by fuliwu on 16/3/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LFDNetworkModel;

@interface LFDNetworkManager : NSObject


+ (NSURLSessionTask *)postRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

+ (NSURLSessionTask *)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

//get请求加上数据过滤处理的回调
+ (NSURLSessionTask *)getRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
                                   sign:(BOOL)sign modelClass:(Class)modelClass filterBlock:(id (^)(id object))filterBlock complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

+ (NSURLSessionTask *)restGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

+ (NSURLSessionTask *)uploadFileToUrl:(NSString *)url parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *uploadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *filePath, NSError *error))complete;
+ (NSURLSessionTask *)uploadFileToUrl:(NSString *)url parameters:(NSDictionary *)parameters bodyData:(NSData *)bodyData progress:(void (^)(NSProgress *uploadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *filePath, NSError *error))complete;

+ (NSURLSessionTask *)downloadFileFromUrl:(NSString *)url parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *downloadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *localFile, NSError *error))complete;
//非证书认证
+ (NSURLSessionTask *)downloadFileFromUrl:(NSString *)url ssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *)parameters localPath:(NSString *)localFile progress:(void (^)(NSProgress *downloadProgress))progress complete:(void (^)(BOOL success, NSString *url, NSString *localFile, NSError *error))complete;


+ (void)testResponse;
+ (void)testUpload;
+ (void)testDownload;
+ (void)testHttp2;

+ (void)testPostRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

+ (void)testGetRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sign:(BOOL)sign modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

+ (void)testRestGetRequestWithUrl:(NSString *)url parameters:(NSArray *)parameters modelClass:(Class)modelClass complete:(void (^)(BOOL success, LFDNetworkModel *responseObject))complete;

@end
