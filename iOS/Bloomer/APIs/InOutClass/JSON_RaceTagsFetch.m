//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_RaceTagsFetch.h"

@implementation JSON_RaceTagsFetch

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *output = json[k_RACENAMES];
        self.tagList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < output.count; i++) {
            NSDictionary *temp = output[i];
            childs *newChild = [[childs alloc] initWithName:temp[k_NAME] key:temp[k_KEY]];
            [self.tagList addObject:newChild];
        }
    }
    return self;
}

@end
