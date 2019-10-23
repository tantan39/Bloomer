//
//  API_PopUpTopWinners.m
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_PopUpTopWinners.h"

@implementation API_PopUpTopWinners

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken
{
    NSDictionary *params = @{k_ACCESS_TOKEN: accessToken,
                             k_DEVICE_TOKEN: deviceToken};
    self = [super initWith:[APIDefine getTopWinnersLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json
{
    JSON_TopWinners *topWinners;

    if (json)
    {
        topWinners = [[JSON_TopWinners alloc] initWithJSON:json];
    }
    
    return (BaseJSON*)topWinners;
}

@end
