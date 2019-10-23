//
//  out_auth_logout.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/10/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_auth_logout.h"

@implementation out_auth_logout

@synthesize msg;

-(void)extractData:(NSDictionary*) data
{
    msg = [data objectForKey:k_MSG];
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        msg = [json objectForKey:k_MSG];
    }
    return self;
}

@end
