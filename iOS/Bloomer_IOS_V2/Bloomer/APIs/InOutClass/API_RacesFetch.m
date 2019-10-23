//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RacesFetch.h"

@implementation API_RacesFetch

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                      key:(NSString *)key
                     ckey:(NSString *)ckey
                     rank:(NSInteger)rank
                isRefresh:(BOOL)isRefresh
                   gender:(NSInteger)gender {
    
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_CKEY: ckey,  
                             k_RANK: @(rank).stringValue,
                             k_IS_REFRESH: isRefresh ? @"true": @"false",
                             k_GENDER: @(gender).stringValue
                             };
    self = [super initWith:[APIDefine race_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RacesFetch *model;
    if (json) {
        model = [[JSON_RacesFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
