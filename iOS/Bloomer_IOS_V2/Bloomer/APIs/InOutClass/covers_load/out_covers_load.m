//
//  out_covers_load.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_covers_load.h"

@implementation out_covers_load

-(void)extractData:(NSDictionary*) data
{
    _covers = [[NSMutableArray alloc] init];
    
    NSArray *array = [data objectForKey:k_PHOTOS];
    for (NSInteger i = 0; i < array.count; i++)
    {
        NSDictionary *cover = [array objectAtIndex:i];
        covers *temp = [[covers alloc] init];
        
        [temp extractData:cover];
        [_covers addObject:temp];
    }
}

@end
