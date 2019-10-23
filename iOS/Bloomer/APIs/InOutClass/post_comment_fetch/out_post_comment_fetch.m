//
//  out_post_comment_fetch.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_post_comment_fetch.h"

@implementation out_post_comment_fetch

@synthesize comments;

//-(void)extractData:(NSDictionary *) data
//{
//    comments = [[NSMutableArray alloc] init];
//
//    NSArray *output = [data objectForKey:k_COMMENTS];
//
//    NSInteger n = [output count];
//
//    for (NSInteger i = 0 ; i< n ; i++)
//    {
//        NSDictionary *temp = [output objectAtIndex:i];
//
//        comment *newcomments = [[comment alloc] init];
//
//        [newcomments extractData:temp];
//
//        [comments addObject:newcomments];
//    }
//
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        comments = [[NSMutableArray alloc] init];
        
        NSArray *output = [json objectForKey:k_COMMENTS];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++)
        {
            NSDictionary *temp = [output objectAtIndex:i];
            
            comment *newcomments = [[comment alloc] initWithJSON:temp];
            
            [comments addObject:newcomments];
        }
    }
    if ([json objectForKey:k_FINAL_COMMEMT] != nil) {
        _isFinal = [[json objectForKey:k_FINAL_COMMEMT] boolValue];
        }
    return self;
}

@end
