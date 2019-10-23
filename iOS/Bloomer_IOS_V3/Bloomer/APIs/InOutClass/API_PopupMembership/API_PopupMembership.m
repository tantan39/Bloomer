//
//  API_PopupMembership.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PopupMembership.h"

@implementation API_PopupMembership

-(id)initWithAccessToken:(NSString *)access_token deviceId:(NSString *)device_id {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_id};
    self = [super initWith:[APIDefine getPopupMembership] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_PopupMembership *model;
    if(json) {
        model = [[JSON_PopupMembership alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
