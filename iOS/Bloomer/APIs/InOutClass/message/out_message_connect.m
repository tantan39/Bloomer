//
//  out_message_connect.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/31/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_message_connect.h"

@implementation out_message_connect

//-(void)extractData:(NSDictionary*) data
//{
//    _auth_session = [data objectForKey:k_AUTH_SESSION];
//    _expire_time = [[data objectForKey:k_EXPIRED_TIME] integerValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _auth_session = [json objectForKey:k_AUTH_SESSION];
        _expire_time = [[json objectForKey:k_EXPIRED_TIME] integerValue];
    }
    return self;
}

@end
