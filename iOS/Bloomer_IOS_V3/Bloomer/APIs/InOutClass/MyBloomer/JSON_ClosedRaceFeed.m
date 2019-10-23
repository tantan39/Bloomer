//
//  JSON_ClosedRaceFeed.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_ClosedRaceFeed.h"

@implementation JSON_ClosedRaceFeed

-(instancetype)initWithJSON:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _raceURL = [data objectForKey:k_URL_RACE_CLOSE];
        
        NSArray *winners = [data objectForKey:k_WINNERS];
        _winnerList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0 ; i < winners.count ; i++) {
            NSDictionary *winner = [winners objectAtIndex:i];
            
            FeedWinner *new = [[FeedWinner alloc] initWithUserID:[[winner objectForKey:k_UID] integerValue]
                                                            moCode:[winner objectForKey:k_MOCODE]
                                                              name:[winner objectForKey:k_NAME]
                                                            avatar:[winner objectForKey:k_AVATAR]
                                                            spCode:[winner objectForKey:k_SPCODE]
                                                          username:[winner objectForKey:k_USERNAME]
                                                            flower:[[winner objectForKey:k_FLOWER] integerValue] ];
            [_winnerList addObject:new];
        }
    }
    return self;
}

@end
