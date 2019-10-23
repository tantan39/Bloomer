//
//  out_block_fetch.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_block_fetch.h"

@implementation out_block_fetch

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_BLOCKERS];
        
        _blockers = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < output.count; i++)
        {
            NSDictionary *temp = [output objectAtIndex:i];
            
            blocker *newBlocker = [[blocker alloc] initWithJSON:temp];
            
            [_blockers addObject:newBlocker];
        }
    }
    return self;
}


@end
