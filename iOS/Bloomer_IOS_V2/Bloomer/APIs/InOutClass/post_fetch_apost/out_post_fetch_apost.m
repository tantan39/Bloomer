//
//  out_post_fetch_apost.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_post_fetch_apost.h"

@implementation out_post_fetch_apost

@synthesize aPost;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        
        NSDictionary * output = [json objectForKey:k_POST];
        aPost = [[post_detail alloc] initWithJSON:output];
    }
    return self;
}

@end
