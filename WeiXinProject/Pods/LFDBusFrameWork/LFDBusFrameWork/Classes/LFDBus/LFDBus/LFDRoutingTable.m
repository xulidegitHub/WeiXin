//
//  LFDRoutingTable.m
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDRoutingTable.h"
#import "LFDRouteConnectorProtocol.h"
#import "LFDRoutingEntry.h"

@interface LFDRoutingTable ()
{
    ;
}

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation LFDRoutingTable

+ (nullable instancetype)shared {
    static LFDRoutingTable *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[LFDRoutingTable alloc] init];
        }
    });
    return instance;
}

- (nullable instancetype)init {
    self = [super init];
    if (self) {
        _routes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerConnector:(nonnull id<LFDRouteConnectorProtocol>)connector {
    if (!connector || ![connector conformsToProtocol:@protocol(LFDRouteConnectorProtocol)]) {
        return;
    }
    
    @synchronized (self) {
        NSDictionary<NSString *, LFDRoutingEntry *> *supportURLs = connector.entries;
        [supportURLs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull url, LFDRoutingEntry * _Nonnull entry, BOOL * _Nonnull stop) {
            [self mapURL:url toEntry:entry];
        }];
    }
}

- (void)unregisterConnector:(nonnull id<LFDRouteConnectorProtocol>)connector {
    if (!connector || ![connector conformsToProtocol:@protocol(LFDRouteConnectorProtocol)]) {
        return;
    }
    
    @synchronized (self) {
        NSDictionary<NSString *, LFDRoutingEntry *> *supportURLs = connector.entries;
        [supportURLs enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull url, LFDRoutingEntry * _Nonnull entry, BOOL * _Nonnull stop) {
            [self unmapURL:url fromEntry:entry];
        }];
    }
}

- (nullable NSDictionary *)mapURL:(nonnull NSString *)url parameters:(nullable NSDictionary *)params {
    NSMutableDictionary *result = [self paramsInURL:url];
    if (result) {
        [result addEntriesFromDictionary:params];
    }
    
    return result;
}

#pragma url utils
- (NSArray *)pathComponentsFromURL:(NSString *)urlStr {
    NSMutableArray *pathComponents = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    for (NSString *pathComponent in url.path.pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:[pathComponent stringByRemovingPercentEncoding]];
    }
    
    return [pathComponents copy];
}

- (NSString *)stringFromFilterAppURLScheme:(NSString *)string {
    // filter out the app URL compontents.
    for (NSString *appURLScheme in [self appURLSchemes]) {
        if ([string hasPrefix:[NSString stringWithFormat:@"%@:", appURLScheme]]) {
            return [string substringFromIndex:appURLScheme.length + 3];
        }
    }
    
    return string;
}

- (NSArray *)appURLSchemes {
    NSMutableArray *appURLSchemes = [NSMutableArray array];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    for (NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"]) {
        NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
        [appURLSchemes addObject:appUrlScheme];
    }
    
    return [appURLSchemes copy];
}

#pragma routing table
- (void)mapURL:(NSString *)url toEntry:(LFDRoutingEntry *)entry {
    if (!entry && ![entry isKindOfClass:[LFDRoutingEntry class]]) {
        return;
    }
    
    NSArray *pathComponents = [self pathComponentsFromURL:url];
    
    NSInteger index = 0;
    NSMutableDictionary *subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString *pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    
    subRoutes[kLFDRoutingEntryKey] = entry;
}

- (void)unmapURL:(NSString *)url fromEntry:(LFDRoutingEntry *)entry {
    if (!entry && ![entry isKindOfClass:[LFDRoutingEntry class]]) {
        return;
    }
    
    NSArray *pathComponents = [self pathComponentsFromURL:url];
    
    NSInteger index = 0;
    NSMutableDictionary *subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString *pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    
    LFDRoutingEntry *usingEntry = (LFDRoutingEntry *)(subRoutes[kLFDRoutingEntryKey]);
    if (usingEntry.connector == entry.connector) {
        subRoutes[kLFDRoutingEntryKey] = nil;
    }
}

- (NSMutableDictionary *)paramsInURL:(NSString *)url {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    url = [self stringFromFilterAppURLScheme:url];
    
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromURL:url];
    for (NSString *pathComponent in pathComponents) {
        BOOL found = NO;
        if (subRoutes[pathComponent]) {
            found = YES;
            subRoutes = subRoutes[pathComponent];
        } else {
            NSArray *subRoutesKeys = subRoutes.allKeys;
            for (NSString *key in subRoutesKeys) {
                if ([key hasPrefix:kLFDRoutingRestfulParameterPrefix]) {
                    found = YES;
                    subRoutes = subRoutes[key];
                    params[[key substringFromIndex:1]] = pathComponent;
                    break;
                }
            }
        }
        if (!found || ![subRoutes isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
    }
    
    if (!subRoutes[kLFDRoutingEntryKey]) {
        return nil;
    }
    
    // Extract Params From Query.
    NSRange firstRange = [url rangeOfString:@"?"];
    if (firstRange.location != NSNotFound && url.length > firstRange.location + firstRange.length) {
        NSString *paramsString = [url substringFromIndex:firstRange.location + firstRange.length];
        NSArray *paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                params[key] = [value stringByRemovingPercentEncoding];
            }
        }
    }
    
    // 若entry指定了reusable，赋给外围
    LFDRoutingEntry *entry = subRoutes[kLFDRoutingEntryKey];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    // 取Default参数
    [result addEntriesFromDictionary:entry.defaultParams];
    // 更新解析出的参数
    [result addEntriesFromDictionary:params];
    
    result[kLFDRoutingEntryKey] = entry;
    result[kLFDRoutingURLKey] = [pathComponents componentsJoinedByString:@"/"];
    // 传递reusable参数
    result[kLFDRoutingEntryReusableKey] = @(entry.reusable);
    
    return result;
}

@end
