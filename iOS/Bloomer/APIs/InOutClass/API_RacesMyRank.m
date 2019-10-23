//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RacesMyRank.h"

@implementation API_RacesMyRank

- (id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                    ckey:(NSString *)ckey {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_CKEY: ckey,
                             };
    self = [super initWith:[APIDefine races_MyRank_fetchesLink] Params:params];
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
