//
//  out_sponsor_fetch.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_sponsor_fetch.h"

@implementation out_sponsor_fetch

@synthesize sponsorData;

//-(void)extractData:(NSDictionary *)data
//{
//    sponsorData = [[NSMutableArray alloc] init];
//
//    NSArray* output = [data objectForKey:k_SPONSORS];
//
//    NSInteger n = [output count];
//
//    for(NSInteger i = 0; i < n; i++)
//    {
//        NSDictionary* temp = [output objectAtIndex:i];
//
//        sponsors *addData = [[sponsors alloc] init];
//
//        [addData extractData:temp];
//
//        [sponsorData addObject:addData];
//    }
//
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        sponsorData = [[NSMutableArray alloc] init];
        
        NSArray* output = [json objectForKey:k_SPONSORS];
        
        NSInteger n = [output count];
        
        for(NSInteger i = 0; i < n; i++)
        {
            NSDictionary* temp = [output objectAtIndex:i];
            
            sponsors *addData = [[sponsors alloc] initWithJSON:temp];
            
            [sponsorData addObject:addData];
        }
    }
    return self;
}

@end
