//
//  API_LoadPrevousRace.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_LoadPrevousRace.h"

@implementation API_LoadPrevousRace
- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                      key:(NSString *)key
                     ckey:(NSString *)ckey
                     rank:(NSInteger)rank
                   gender:(NSInteger)gender
                scroll:(NSInteger) scroll {
    
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_CKEY: ckey,
                             k_RANK: @(rank).stringValue,
                             k_SCROLL: @(scroll).stringValue,
                             k_GENDER: @(gender).stringValue
                             };
    self = [super initWith:[APIDefine getRaceMoreScrollLink] Params:params];
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
