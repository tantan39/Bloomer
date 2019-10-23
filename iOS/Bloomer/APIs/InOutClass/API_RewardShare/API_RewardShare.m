//
//  API_RewardShare.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 1/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_RewardShare.h"

@implementation API_RewardShare

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken shareID:(NSString*)shareID isPopup:(BOOL)isPopup
{
    NSDictionary *params = @{k_ACCESS_TOKEN: accessToken,
                             k_DEVICE_TOKEN: deviceToken,
                             @"share_id": shareID,
                             @"isPopup": isPopup ? @"true" : @"false",
                             };
    
    self = [super initWith:[APIDefine ShareTopWinner] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json
{
    rewardShare *reward;
    if (json)
    {
        reward = [[rewardShare alloc] initWithJSON:json];
    }
    return (BaseJSON*)reward;
}

@end
