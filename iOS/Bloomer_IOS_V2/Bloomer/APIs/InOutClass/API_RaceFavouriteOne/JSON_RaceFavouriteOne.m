//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_RaceFavouriteOne.h"

@implementation JSON_RaceFavouriteOne

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.favourites = [[NSMutableArray alloc] init];
        
        NSArray *array = json[k_RACES];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *fav = array[i];
            RaceFavouriteObj *temp = [[RaceFavouriteObj alloc] init];
            [temp extractData:fav];
            [self.favourites addObject:temp];
        }
    }
    
    return self;
}

@end
