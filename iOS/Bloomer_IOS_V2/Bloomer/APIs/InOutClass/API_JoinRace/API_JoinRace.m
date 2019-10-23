//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_JoinRace.h"

@implementation API_JoinRace

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   key:(NSString *)key photoID:(NSString *)photoID {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             k_PHOTO_ID: photoID,
                             };
    self = [super initWith:[APIDefine joinrace_link] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_JoinRace *model;
    if (json) {
        model = [[JSON_JoinRace alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end


@implementation API_CheckJoinRace

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   key:(NSString *)key {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             };
    self = [super initWith:[APIDefine checkjoinedrace_link] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_CheckJoinRace *model;
    if (json) {
        model = [[JSON_CheckJoinRace alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
