//
//  API_Discovery_Fetches.m
//  Bloomer
//
//  Created by Ahri on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_DiscoveryFetches.h"

@implementation API_DiscoveryFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                             gender:(NSInteger)gender is_refresh:(BOOL)isRefresh uid:(NSInteger)uid {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_GENDER: @(gender).stringValue,
                             k_IS_REFRESH: isRefresh ? @"true" : @"false",
                             k_UID: @(uid).stringValue
                             };
    self = [super initWith:[APIDefine discovery_fetchesLink] Params:params];
    return self;
}

- (instancetype)initWithGender:(NSInteger)gender city:(NSString *)city is_refresh:(BOOL)is_refresh uid:(NSInteger)uid {
    NSDictionary *params = @{
                             k_GENDER: @(gender).stringValue,
                             k_CITY: city,
                             k_IS_REFRESH: is_refresh ? @"true" : @"false",
                             k_UID: @(uid).stringValue
                             };
    self = [super initWith:[APIDefine anonymous_discovery_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_DiscoveryFetches *model;
    if (json) {
        model = [[JSON_DiscoveryFetches alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
