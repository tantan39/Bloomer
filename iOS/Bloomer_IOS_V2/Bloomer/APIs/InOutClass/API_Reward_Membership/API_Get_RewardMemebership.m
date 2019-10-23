//
//  API_Get_RewardMemebership.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Get_RewardMemebership.h"

@implementation API_Get_RewardMemebership

-(instancetype) initWithAccessToken:(NSString*) token deviceId:(NSString*) device andUserId:(NSInteger)uid
{
    self= [super init];
    if(self)
    {
        NSDictionary *params = @{k_ACCESS_TOKEN: token,
                                 k_DEVICE_TOKEN: device,
                                 @"user_id": [@(uid) stringValue]};
        self = [super initWith:[APIDefine getRewardMembership] Params:params];
    }
    return self;
}

- (BaseJSON *) handleJSON:(NSDictionary *) json
{
    RewardMembership* dataJson;
    if(json)
    {
        dataJson = [[RewardMembership alloc] initWithJSON:json];
    }
    return (BaseJSON*)dataJson;
}


@end
