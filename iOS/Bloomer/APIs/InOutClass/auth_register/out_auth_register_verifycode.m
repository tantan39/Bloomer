//
//  out_auth_register_verifycode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_auth_register_verifycode.h"

@implementation out_auth_register_verifycode

//-(void)extractData:(NSDictionary*) data
//{
//    NSDictionary* auth;
//
//    if ([data objectForKey:k_AUTH] != [NSNull null])
//    {
//        auth = [data objectForKey:k_AUTH];
//        
//        _access_token = [auth objectForKey:k_ACCESS_TOKEN];
//        _refresh_token = [auth objectForKey:k_REFRESH_TOKEN];
//        _expire_time = [auth objectForKey:k_EXPIRED_TIME];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary* auth;
        
        if ([json objectForKey:k_AUTH] != [NSNull null])
        {
            auth = [json objectForKey:k_AUTH];
            
            _access_token = [auth objectForKey:k_ACCESS_TOKEN];
            _refresh_token = [auth objectForKey:k_REFRESH_TOKEN];
            _expire_time = [auth objectForKey:k_EXPIRED_TIME];
        }

    }
    
    return self;
    
}

@end
