//
//  out_rank_history.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/14/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "JSON_Achievement.h"

@implementation JSON_Achievement

-(void)extractData:(NSDictionary*) data
{
    /*
    _active_ranks = [[NSMutableArray alloc] init];
    _history_rank = [[NSMutableArray alloc] init];
    
    NSArray *array = [data objectForKey:k_ACTIVE_RANKS];
    
    for(NSInteger i = 0; i < array.count; i++)
    {
        NSDictionary *rak = [array objectAtIndex:i];
        achievement *temp = [[achievement alloc] init];
        
        [temp extractData:rak];
        [_active_ranks addObject:temp];
    }
    
    NSArray *arrays = [data objectForKey:k_HISTORY_RANKS];
    
    for(NSInteger i = 0; i < arrays.count; i++)
    {
        NSDictionary *rak = [arrays objectAtIndex:i];
        achievement *temp = [[achievement alloc] init];
        
        [temp extractData:rak];
        [_history_rank addObject:temp];
    }
     */
    
    _achievements = [[NSMutableArray alloc] init];
    _keyEnd = [data objectForKey:@"keyend"];
    NSArray *array = [data objectForKey:k_ACHIVEMENTS];
    
    for(NSInteger i = 0; i < array.count; i++)
    {
        NSDictionary *achievementRace = [array objectAtIndex:i];
        // check isChild key to get Timestamp results
        if([[achievementRace objectForKey:k_ISCHILD] boolValue]){
            AchievementModel *achiev = [[AchievementModel alloc] init];
            achiev.raceKey = [achievementRace objectForKey:k_KEY];
            achiev.raceName = [achievementRace objectForKey:k_NAME];
            achiev.num_flower = [[achievementRace objectForKey:k_FLOWER] longLongValue];
            achiev.childs = [[NSMutableArray alloc] init];
            NSArray *childArray = [achievementRace objectForKey:k_CHILDS];
            for (NSInteger i =0; i < childArray.count; i++) {
                AchievementModel *childAchiev = [[AchievementModel alloc] init];
                childAchiev.raceKey = [childArray[i] objectForKey:k_KEY];
                childAchiev.raceName = [childArray[i] objectForKey:k_NAME];
                childAchiev.rank = [[childArray[i] objectForKey:k_RANK] integerValue];
                childAchiev.childs = nil;
                [achiev.childs addObject:childAchiev];
            }
            [_achievements addObject:achiev];
            
        } else { // no childs
            AchievementModel *achiev = [[AchievementModel alloc] init];
            achiev.raceKey = [achievementRace objectForKey:k_KEY];
            achiev.raceName = [achievementRace objectForKey:k_NAME];
            achiev.rank = [[achievementRace objectForKey:k_RANK] integerValue];
            achiev.num_flower = [[achievementRace objectForKey:k_FLOWER] longLongValue];
            achiev.childs = nil;
            [_achievements addObject:achiev];
        }
    }
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _achievements = [[NSMutableArray alloc] init];
        _keyEnd = [json objectForKey:@"keyend"];
        NSArray *array = [json objectForKey:k_ACHIVEMENTS];
        
        for(NSInteger i = 0; i < array.count; i++)
        {
            NSDictionary *achievementRace = [array objectAtIndex:i];
            // check isChild key to get Timestamp results
            if([[achievementRace objectForKey:k_ISCHILD] boolValue]){
                AchievementModel *achiev = [[AchievementModel alloc] init];
                achiev.raceKey = [achievementRace objectForKey:k_KEY];
                achiev.raceName = [achievementRace objectForKey:k_NAME];
                achiev.num_flower = [[achievementRace objectForKey:k_FLOWER] longLongValue];
                achiev.childs = [[NSMutableArray alloc] init];
                NSArray *childArray = [achievementRace objectForKey:k_CHILDS];
                for (NSInteger i =0; i < childArray.count; i++) {
                    AchievementModel *childAchiev = [[AchievementModel alloc] init];
                    childAchiev.raceKey = [childArray[i] objectForKey:k_KEY];
                    childAchiev.raceName = [childArray[i] objectForKey:k_NAME];
                    childAchiev.rank = [[childArray[i] objectForKey:k_RANK] integerValue];
                    childAchiev.childs = nil;
                    [achiev.childs addObject:childAchiev];
                }
                [_achievements addObject:achiev];
                
            } else { // no childs
                AchievementModel *achiev = [[AchievementModel alloc] init];
                achiev.raceKey = [achievementRace objectForKey:k_KEY];
                achiev.raceName = [achievementRace objectForKey:k_NAME];
                achiev.rank = [[achievementRace objectForKey:k_RANK] integerValue];
                achiev.num_flower = [[achievementRace objectForKey:k_FLOWER] longLongValue];
                achiev.childs = nil;
                [_achievements addObject:achiev];
            }
        }
    }
    return self;
}

@end
