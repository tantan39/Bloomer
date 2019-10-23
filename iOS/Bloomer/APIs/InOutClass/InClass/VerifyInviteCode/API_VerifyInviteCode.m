//
//  API_VerifyInviteCode.m
//  Bloomer
//
//  Created by Steven on 12/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "API_VerifyInviteCode.h"

@implementation API_VerifyInviteCode

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token invite_code:(NSString*)invite_code {

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_INVITE_CODE : invite_code
                              };
    self = [super initWith:[APIDefine verifyInviteCodeLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[Json_ShareFacebook alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[Json_ShareFacebook alloc] init];
}

@end
