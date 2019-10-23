//
//  API_RaceSearch.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RaceSearch.h"

@implementation API_RaceSearch

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token key:(NSString *)key ckey:(NSString *)ckey gender:(NSInteger)gender term:(NSString *)term page:(NSInteger)page size:(NSInteger)size {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_CKEY: ckey,
                             k_GENDER: @(gender).stringValue,
                             @"term": term,
                             K_PAGE: @(page),
                             k_SIZE: @(size)};
    self = [super initWith:[APIDefine races_search_fetchesLink] Params:params];
    return self;
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token key:(NSString *)key ckey:(NSString *)ckey gender:(NSInteger)gender term:(NSString *)term {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_CKEY: ckey,
                             k_GENDER: @(gender).stringValue,
                             @"term": term};
    self = [super initWith:[APIDefine races_search_fetchesLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RaceSearch *model;
    if (json) {
        model = [[JSON_RaceSearch alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
