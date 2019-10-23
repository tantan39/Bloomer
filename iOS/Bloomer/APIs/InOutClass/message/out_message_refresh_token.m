//
//  out_message_refresh_token.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/3/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_message_refresh_token.h"

@implementation out_message_refresh_token

//-(void)extractData:(NSDictionary*) data
//{
//    _auth_session = [data objectForKey:k_AUTH_SESSION];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _auth_session = [json objectForKey:k_AUTH_SESSION];
    }
    return self;
}


@end
