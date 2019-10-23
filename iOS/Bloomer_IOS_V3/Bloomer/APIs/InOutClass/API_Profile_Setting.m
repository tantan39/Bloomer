//
//  API_Profile_Setting.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Setting.h"

@implementation API_Profile_Setting

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{
    NSDictionary * params = @{ k_ACCESS_TOKEN : access_token,
                               k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:[APIDefine profile_settingLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_profile_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_profile_fetch alloc] init];
}

@end
