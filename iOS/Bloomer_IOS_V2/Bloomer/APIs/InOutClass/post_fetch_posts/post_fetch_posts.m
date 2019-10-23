//
//  post_fetch_posts.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "post_fetch_posts.h"

@implementation post_fetch_posts

@synthesize arrayPost;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        arrayPost = [[NSMutableArray alloc] init];
        
        NSArray* output = [json objectForKey:k_POSTS];
        
        NSInteger n = [arrayPost count];
        
        for(NSInteger i = 0; i < n; i++)
        {
            NSDictionary* temp = [output objectAtIndex:i];
            
            post_detail *addData = [[post_detail alloc] initWithJSON:temp];
            
            [arrayPost addObject:addData];
        }
    }
    return self;
}

@end
