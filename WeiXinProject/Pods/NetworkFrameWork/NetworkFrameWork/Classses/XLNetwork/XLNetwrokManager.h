//
//  XLNetwrokManager.h
//  Pods
//
//  Created by 徐丽 on 2017/6/7.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "XLNetworkModel.h"
@interface XLNetwrokManager : NSObject
+ (NSString *_Nullable)makeAppKey:(NSDictionary *_Nullable)parameters;
+ (NSString *_Nullable)makeRestUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters;
//post请求--带转模型
+ (NSURLSessionTask *_Nullable)postRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//post请求--不带转模型
+(NSURLSessionTask *_Nullable)postRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign complete:(void (^_Nullable)(BOOL success, id _Nonnull responseObject))complete;
//get请求--带转模型
+ (NSURLSessionTask *_Nullable)getRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//get请求加上数据过滤处理的回调--带转模型
+ (NSURLSessionTask *_Nullable)getRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters
                                   sign:(BOOL)sign modelClass:(Class _Nullable )modelClass filterBlock:(id _Nullable (^_Nullable)(id _Nullable object))filterBlock complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//get请求--不带转模型的
+(NSURLSessionTask *_Nullable)getRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign  complete:(void (^_Nullable)(BOOL success,id  _Nonnull responseObject))complete;
//get请求--不带转模型，带过滤参数
+ (NSURLSessionTask *_Nullable)getRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters
                                             sign:(BOOL)sign  filterBlock:(id _Nullable (^_Nullable)(id _Nullable object))filterBlock complete:(void (^_Nullable)(BOOL success, id  _Nonnull responseObject))complete;
//get请求--带转模型的，url格式为a/b/c拼接方式的
+ (NSURLSessionTask *_Nullable)restGetRequestWithUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//get请求--不带转模型的，url格式为a/b/c拼接方式的
+ (NSURLSessionTask *_Nullable)restGetRequestNotransferWithUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//上传本地文件--带可选证书
+ (NSURLSessionTask *_Nullable)uploadFileToUrl:(NSString *_Nullable)url andssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *_Nullable)parameters localPath:(NSString *_Nullable)localFile progress:(void (^_Nullable)(NSProgress * _Nullable uploadProgress))progress complete:(void (^_Nullable)(BOOL success, NSString * _Nullable url, NSString * _Nullable filePath, NSError * _Nullable error))complete;
//上传data文件--带可选证书
+ (NSURLSessionTask *_Nullable)uploadFileToUrl:(NSString *_Nullable)url andssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *_Nullable)parameters bodyData:(NSData *_Nullable)bodyData progress:(void (^_Nullable)(NSProgress * _Nullable uploadProgress))progress complete:(void (^_Nullable)(BOOL success, NSString * _Nullable url, NSString * _Nullable filePath, NSError * _Nullable error))complete;
//下载文件--带可选证书
+ (NSURLSessionTask *_Nullable)downloadFileFromUrl:(NSString *_Nullable)url ssl_certificate:(BOOL)ssl_certificate parameters:(NSDictionary *_Nullable)parameters localPath:(NSString *_Nullable)localFile progress:(void (^_Nullable)(NSProgress * _Nullable downloadProgress))progress complete:(void (^_Nullable)(BOOL success, NSString * _Nullable url, NSString * _Nullable localFile, NSError * _Nullable error))complete;
//处理response,转模型
+ (void)handleResponseObject:(id _Nullable )responseObject modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//处理error信息，转模型
+ (void)handleRequestError:(NSError *_Nullable)error modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//测试数据--post
+ (void)testPostRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//测试数据--get
+ (void)testGetRequestWithUrl:(NSString *_Nullable)url parameters:(NSDictionary *_Nullable)parameters sign:(BOOL)sign modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;
//测试数据--restget
+ (void)testRestGetRequestWithUrl:(NSString *_Nullable)url parameters:(NSArray *_Nullable)parameters modelClass:(Class _Nullable )modelClass complete:(void (^_Nullable)(BOOL success, XLNetworkModel * _Nullable responseObject))complete;

+ (void)testResponse;
+ (void)testUpload;
+ (void)testDownload;
+ (void)testHttp2;
@end
