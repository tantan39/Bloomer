//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RacesNameFetch.h"

@implementation API_RacesNameFetch

- (id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_IS_NEW: @"true"
                             };
    self = [super initWith:[APIDefine race_name_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RacesNameFetch *model;
    if (json) {
        model = [[JSON_RacesNameFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
