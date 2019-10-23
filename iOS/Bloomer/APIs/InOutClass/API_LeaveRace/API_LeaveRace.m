//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_LeaveRace.h"

@implementation API_LeaveRace

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   key:(NSString *)key {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_KEY: key,
                             };
    self = [super initWith:[APIDefine leaverace_link] Params:params];
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
