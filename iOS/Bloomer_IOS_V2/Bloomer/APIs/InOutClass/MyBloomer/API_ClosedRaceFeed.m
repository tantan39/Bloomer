//
//  API_ClosedRaceFeed.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_ClosedRaceFeed.h"

@implementation API_ClosedRaceFeed

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token key:(NSString *)key gender:(NSInteger)gender {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_GENDER: @(gender)};
    self = [super initWith:[APIDefine race_feed_fetchesLink] Params:params];
    return self;
}

-(id)initWithKey:(NSString *)key gender:(NSInteger)gender {
    NSDictionary *params = @{k_KEY: key,
                             k_GENDER: @(gender)};
    self = [super initWith:[APIDefine anonymous_feed_race_closedLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_ClosedRaceFeed *model;
    if(json) {
        model = [[JSON_ClosedRaceFeed alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
