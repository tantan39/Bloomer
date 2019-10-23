//
//  API_RaceList.m
//  Bloomer
//
//  Created by Tu Le on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_RaceList.h"

@implementation API_RaceList

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token gender:(NSInteger)gender {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_GENDER: @(gender).stringValue};
    self = [super initWith:[APIDefine getRaceList] Params:params];
    return self;
}

- (id)initWithGender:(NSInteger)gender {
    NSDictionary *params = @{k_GENDER: @(gender).stringValue};
    self = [super initWith:[APIDefine getAnonymousRaceList] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    NSLog(@"%@",json);
    JSON_RaceList *model;
    if (json) {
        model = [[JSON_RaceList alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
