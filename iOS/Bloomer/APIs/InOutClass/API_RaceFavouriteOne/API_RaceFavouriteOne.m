//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RaceFavouriteOne.h"

@implementation API_RaceFavouriteOne

// device_id=...&post_id=...&user_id=...&limit=...

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token min:(NSInteger)min max:(NSInteger)max {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_MIN: @(min).stringValue,
                             k_MAX: @(max).stringValue,
                             };
    self = [super initWith:[APIDefine race_favourites_oneLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RaceFavouriteOne *model;
    if (json) {
        model = [[JSON_RaceFavouriteOne alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
