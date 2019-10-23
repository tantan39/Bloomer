//
//  API_Auth_Expired.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_Expired.h"

@implementation API_Auth_Expired

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token
                              };
    self = [super initWith:[APIDefine auth_expiredLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    JSON_Auth_Expired* model;
    if(json) {
        model = [[JSON_Auth_Expired alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
