//
//  out_auth_refresh_token.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_auth_refresh_token.h"

@implementation out_auth_refresh_token

//-(void)extractData:(NSDictionary*) data
//{
//    _access_token = [data objectForKey:k_ACCESS_TOKEN];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _access_token = [json objectForKey:k_ACCESS_TOKEN];
    }
    
    return self;
}

@end
