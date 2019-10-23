
//
//  out_rooms_fetch.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/6/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_rooms_fetch.h"

@implementation out_rooms_fetch

@synthesize roomsData;

//-(void)extractData:(NSDictionary *)data
//{
//    roomsData = [[NSMutableArray alloc] init];
//    NSArray* output = [data objectForKey:k_ROOMS];
//    
//    for(NSInteger i = 0; i < output.count; i++)
//    {
//        NSDictionary* temp = [output objectAtIndex:i];
//        room *r = [[room alloc] init];
//        [r extractData:temp];
//        [roomsData addObject:r];
//    }
//    
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        roomsData = [[NSMutableArray alloc] init];
        NSArray* output = [json objectForKey:k_ROOMS];
        
        for(NSInteger i = 0; i < output.count; i++)
        {
            NSDictionary* temp = [output objectAtIndex:i];
            room *r = [[room alloc] initWithJSON:temp];
            [roomsData addObject:r];
        }
    }
    return self;
}

@end
