//
//  API_DiscoverySearch.m
//  Bloomer
//
//  Created by Ahri on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_DiscoverySearch.h"

@implementation API_DiscoverySearch

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                     term:(NSString *)term size:(NSInteger)size page:(NSInteger)page {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_TERMSEARCH: term,
                             K_PAGE: @(page).stringValue
                             };
    self = [super initWith:[APIDefine discovery_searchLink] Params:params];
    return self;
}

- (id)initWithTerm:(NSString *)term size:(NSInteger)size page:(NSInteger)page {
    NSDictionary *params = @{
                             k_TERMSEARCH: term,
                             K_PAGE: @(page).stringValue,
                             k_GENDER: @"0"
                             };
    self = [super initWith:[APIDefine anonymous_discovery_searchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_DiscoverySearch *model;
    if (json) {
        model = [[JSON_DiscoverySearch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
