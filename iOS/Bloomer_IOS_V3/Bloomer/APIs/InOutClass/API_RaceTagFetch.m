//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RaceTagFetch.h"

@implementation API_RaceTagFetch

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             };
    self = [super initWith:[APIDefine race_tag_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RaceTagsFetch *model;
    if (json) {
        model = [[JSON_RaceTagsFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
