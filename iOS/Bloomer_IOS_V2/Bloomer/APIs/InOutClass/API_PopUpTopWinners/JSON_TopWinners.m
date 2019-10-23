//
//  JSON_TopWinners.m
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_TopWinners.h"

@implementation JSON_TopWinners

- (instancetype) initWithJSON:(NSDictionary *)json
{
    self = [super init];
    
    if (self)
    {
        self.flower = [[json objectForKey:k_FLOWER] integerValue];
        self.topWinners = [[NSMutableArray alloc] init];
        NSArray *tempTopWinners = [json objectForKey:K_POPUPS];
        
        for (NSInteger i = 0; i < tempTopWinners.count; i++)
        {
            NSDictionary *dictionary = tempTopWinners[i];
            TopWinner *topWinner = [[TopWinner alloc] initWithAvatar:[dictionary objectForKey:k_AVATAR]
                                                             message:[dictionary objectForKey:k_MESSAGE]
                                                             popUpID:[dictionary objectForKey:@"popup_id"]
                                                            position:[[dictionary objectForKey:K_POSITION] integerValue]
                                                             raceKey:[dictionary objectForKey:k_RACE_KEY]
                                                            raceName:[dictionary objectForKey:k_RACE_NAME]
                                                                type:[dictionary objectForKey:k_TYPE]
                                                                 url:[dictionary objectForKey:K_URL]];
            [self.topWinners addObject:topWinner];
        }
    }
    
    return self;
}

@end
