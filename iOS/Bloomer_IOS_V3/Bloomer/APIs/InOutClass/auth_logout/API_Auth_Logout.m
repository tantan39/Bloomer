//
//  API_Auth_Logout.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_Logout.h"

@implementation API_Auth_Logout

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_tokens{
    
    NSDictionary * dict = @{
                            k_ACCESS_TOKEN : access_token ? access_token : @"",
                                k_DEVICE_TOKEN : device_tokens
                            
                            };
    
    self = [super initWith:[APIDefine auth_logoutLink] Params:dict];
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    out_auth_logout * model;
    if (json) {
        model = [[out_auth_logout alloc] initWithJSON:json];
    }
    
    return (BaseJSON *)model;
}

@end
