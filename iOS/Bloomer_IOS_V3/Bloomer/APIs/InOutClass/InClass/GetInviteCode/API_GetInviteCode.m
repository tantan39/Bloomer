//
//  API_GetInviteCode.m
//  Bloomer
//
//  Created by Steven on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "API_GetInviteCode.h"

@implementation API_GetInviteCode

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token};
    self = [super initWith:[APIDefine getInviteCodeLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    Json_InviteCode *model;
    if(json) {
        model = [[Json_InviteCode alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
