//
//  out_regions_fetch.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_regions_fetch.h"

@implementation out_regions_fetch

//-(void)extractData:(NSDictionary*) data
//{
//    _regions = [[NSMutableArray alloc] init];
//
//    NSArray *array = [data objectForKey:k_REGIONS];
//    for (NSInteger i = 0; i < array.count; i++)
//    {
//        NSDictionary *dictionary = [array objectAtIndex:i];
//        region *temp = [[region alloc] init];
//
//        [temp extractData:dictionary];
//        [_regions addObject:temp];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _regions = [[NSMutableArray alloc] init];
        
        NSArray *array = [json objectForKey:k_REGIONS];
        for (NSInteger i = 0; i < array.count; i++)
        {
            NSDictionary *dictionary = [array objectAtIndex:i];
            region *temp = [[region alloc] initWithJSON:dictionary];
            
//            [temp extractData:dictionary];
            [_regions addObject:temp];
        }
    }
    return self;
}


@end
