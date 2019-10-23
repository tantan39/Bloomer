//
//  out_post_create.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_post_create.h"

@implementation out_post_create
@synthesize feed_id;

//-(void)extractData:(NSDictionary*) data
//{
//    feed_id = [data objectForKey:k_FEED_ID];
//
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        feed_id = [json objectForKey:k_FEED_ID];
    }
    return self;
    
}


@end
