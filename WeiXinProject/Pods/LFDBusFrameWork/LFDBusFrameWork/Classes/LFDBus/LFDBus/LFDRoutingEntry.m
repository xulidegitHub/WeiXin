//
//  LFDRoutingEntry.m
//  LFDistributionApp
//
//  Created by liwufu on 2016/11/25.
//  Copyright © 2016年 LetvFinancial. All rights reserved.
//

#import "LFDRoutingEntry.h"
#import "OTOObject.h"

@interface LFDRoutingEntry ()

@property (nonatomic, weak) id<LFDRouteConnectorProtocol> _Nullable connector;
@property (nonatomic, strong) NSDictionary *rules;

@end

@implementation LFDRoutingEntry

+ (nullable instancetype)entryWithConnector:(nonnull id<LFDRouteConnectorProtocol>)connector rules:(nullable NSDictionary *)rules {
    return [[LFDRoutingEntry alloc] initWithConnector:connector rules:rules];
}

- (nullable instancetype)initWithConnector:(nonnull id<LFDRouteConnectorProtocol>)connector rules:(nullable NSDictionary *)rules {
    self = [super init];
    if (self) {
        self.connector = connector;
        self.rules = rules;
    }
    return self;
}

- (nullable instancetype)entryByUpdateRules:(nonnull NSDictionary *)rules {
    LFDRoutingEntry *entry = [[LFDRoutingEntry alloc] init];
    if (entry) {
        entry.connector = _connector;
        NSMutableDictionary *newRules = [_rules mutableCopy];
        [newRules addEntriesFromDictionary:rules];
        entry.rules = [newRules copy];
    }
    return entry;
}

- (nullable id)accelerator {
    return _rules[kLFDRoutingEntryAcceleratorKey];
}

- (BOOL)reusable {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryReusableKey] ofClass:[NSNumber class]]) {
        return ((NSNumber *)_rules[kLFDRoutingEntryReusableKey]).boolValue;
    }
    
    return YES;
}

- (BOOL)customDisplay {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryCustomDisplayKey] ofClass:[NSNumber class]]) {
        return ((NSNumber *)_rules[kLFDRoutingEntryCustomDisplayKey]).boolValue;
    }
    
    return NO;
}

- (LFDRoutingAppearMode)appearMode {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryAppearModeKey] ofClass:[NSNumber class]]) {
        return ((NSNumber *)_rules[kLFDRoutingEntryAppearModeKey]).integerValue;
    }
    
    return LFDRoutingAppearModeDefault;
}

- (LFDRoutingTabbarMode)tabbarMode {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryTabbarModeKey] ofClass:[NSNumber class]]) {
        return ((NSNumber *)_rules[kLFDRoutingEntryTabbarModeKey]).integerValue;
    }
    
    return LFDRoutingTabbarModeDefault;
}

- (nullable NSString *)viaRoute {
    if ([OTOObject isNonEmptyString:_rules[kLFDRoutingEntryViaRouteKey]]) {
        return (NSString *)_rules[kLFDRoutingEntryViaRouteKey];
    }
    
    return nil;
}

- (nullable NSDictionary *)viaRouteParams {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryViaRouteParamsKey] ofClass:[NSDictionary class]]) {
        return (NSDictionary *)_rules[kLFDRoutingEntryViaRouteParamsKey];
    }
    
    return nil;
}

- (NSArray<NSString *> *)require {
    if ([OTOObject isNonEmptyString:_rules[kLFDRoutingEntryRequireKey]]) {
        return [(NSString *)_rules[kLFDRoutingEntryRequireKey] componentsSeparatedByString:kLFDRoutingEntryRequireSeperator];
    }
    
    return nil;
}

- (nullable NSDictionary *)defaultParams {
    if ([OTOObject isNonEmptyObject:_rules[kLFDRoutingEntryDefaultParamsKey] ofClass:[NSDictionary class]]) {
        return (NSDictionary *)_rules[kLFDRoutingEntryDefaultParamsKey];
    }
    
    return nil;
}

@end
