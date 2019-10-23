//
//  out_post_comment.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_post_comment.h"


@implementation out_post_comment

@synthesize comment_id;

//-(void)extractData:(NSDictionary*) data
//{
//    comment_id = [data objectForKey:k_COMMENT_ID];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        comment_id = [json objectForKey:k_COMMENT_ID];
    }
    return self;
}

@end
