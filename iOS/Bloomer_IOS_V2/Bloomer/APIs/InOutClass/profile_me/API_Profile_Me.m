//
//  API_Profile_Me.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Me.h"

@implementation API_Profile_Me

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{
    
    NSDictionary * dict = @{ k_ACCESS_TOKEN : access_token,
                             k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:[APIDefine profile_meLink] Params:dict];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_profile_fetch * model;
    if (json) {
        model = [[out_profile_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
