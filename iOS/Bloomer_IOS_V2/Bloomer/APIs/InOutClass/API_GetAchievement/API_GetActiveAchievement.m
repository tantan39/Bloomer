//
//  API_GetActiveAchievement.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_GetActiveAchievement.h"

@implementation API_GetActiveAchievement

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token user_id:(NSInteger)user_id {
    self = [super init];
    if (self) {
        NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                                 k_DEVICE_TOKEN: device_token,
                                 @"user_id": [@(user_id) stringValue]};
        self = [super initWith:[APIDefine new_rank_active_history] Params:params];
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token user_id:(NSInteger)user_id andKey:(NSString*)key {
    self = [super init];
    if (self) {
        NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                                 k_DEVICE_TOKEN: device_token,
                                 @"user_id": [@(user_id) stringValue],
                                 @"key":key};
        self = [super initWith:[APIDefine new_rank_active_history] Params:params];
    }
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_Achievement* dataJson;
    if (json) {
        dataJson = [[JSON_Achievement alloc] initWithJSON:json];
    }
    return (BaseJSON *)dataJson;
}


@end
