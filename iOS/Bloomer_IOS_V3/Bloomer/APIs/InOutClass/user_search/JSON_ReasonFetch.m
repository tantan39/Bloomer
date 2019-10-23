//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_ReasonFetch.h"

@implementation JSON_ReasonFetch

@synthesize reasonList;

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *output = json[@"data"];
        reasonList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < output.count; i++) {
            NSDictionary *temp = output[i];
            
            reason *new = [[reason alloc] initWithType:[temp[k_TYPE] integerValue]
                                                   ids:[temp[k_ID] integerValue]
                                                active:[temp[k_ACTIVE] boolValue]
                                               content:temp[k_CONTENT]];
            
            [reasonList addObject:new];
        }
    }
    return self;
}

@end
