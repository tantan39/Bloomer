//
//  out_race_feed.m
//  Bloomer
//
//  Created by VanLuu on 6/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_race_feed.h"

@implementation out_race_feed
@synthesize winnerList;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _raceURL = [json objectForKey:k_URL_RACE_CLOSE];
        
        NSArray *winners = [json objectForKey:k_WINNERS];
        winnerList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0 ; i < winners.count ; i++) {
            NSDictionary *winner = [winners objectAtIndex:i];
            
            feed_winner *new = [[feed_winner alloc] initWithUserID:[[winner objectForKey:k_UID] integerValue]
                                                            moCode:[winner objectForKey:k_MOCODE]
                                                              name:[winner objectForKey:k_NAME]
                                                            avatar:[winner objectForKey:k_AVATAR]
                                                            spCode:[winner objectForKey:k_SPCODE]
                                                          username:[winner objectForKey:k_USERNAME]
                                                            flower:[[winner objectForKey:k_FLOWER] integerValue] ];
            [winnerList addObject:new];
        }
    }
    return self;
}
@end
