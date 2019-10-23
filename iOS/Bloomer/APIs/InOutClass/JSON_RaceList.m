//
//  out_races_list_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "JSON_RaceList.h"

@implementation JSON_RaceList

@synthesize categoryList, racesByCategory;

- (id)initWithJSON:(NSDictionary *)data {
    self = [super init];
    if(self) {
        NSDictionary *category = [data objectForKey:k_ACTIVED_RACES];
        NSArray *listCategory = [category allKeys];
        
        //AVAILABLE RACES
        // alway have 3 groupd of races : Country-category=1 ; Location-Category=2; Thems-Category > 2
        categoryList = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Country Contests", nil) , NSLocalizedString(@"Location Based Contests",nil), NSLocalizedString(@"Themed Contests",nil), @"Sponsor Contests", @"Exclusive Contests", nil];
        racesByCategory = [[NSMutableDictionary alloc] init];
        NSMutableArray* countryRaces = [[NSMutableArray alloc] init];
        NSMutableArray* locationRaces = [[NSMutableArray alloc] init];
        NSMutableArray* themedRaces = [[NSMutableArray alloc] init];
        NSMutableArray* sponsoredRaces = [[NSMutableArray alloc] init];
        NSMutableArray* exclusiveRaces = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < listCategory.count; i++)
        {
            NSArray *listRaces = [category objectForKey:[listCategory objectAtIndex:i]];
            
            for (int j = 0; j < listRaces.count; j ++)
            {
                NSDictionary *temp = [listRaces objectAtIndex:j];
                races_list *newrace = [[races_list alloc] initWithName:[temp objectForKey:k_NAME]
                                                                isJoin:[[temp objectForKey:k_IS_JOINED] integerValue]
                                                                   key:[temp objectForKey:k_KEY]
                                                                 start:[[temp objectForKey:k_START] longLongValue]
                                                                   end:[[temp objectForKey:k_END] longLongValue]
                                                             startDate:[temp objectForKey:k_DATE_START]
                                                               endDate:[temp objectForKey:k_DATE_END]
                                                              raceInfo:[temp objectForKey:k_RACE_INFO]
                                                              joinInfo:[temp objectForKey:k_JOIN_INFO]
                                                             leaveInfo:[temp objectForKey:k_LEAVE_INFO]
                                                          categoryName:[temp objectForKey:k_CATEGORY_NAME]
                                                                childs:[temp objectForKey:k_CHILDS ]
                                                              isClosed:[[temp objectForKey:k_IS_CLOSED] integerValue]
                                                               isMulti:[[temp objectForKey:k_IS_MULTI] integerValue]
                                                            locationID:[[temp objectForKey:k_LOCATION_ID] integerValue]
                                                              category:[[temp objectForKey:k_CATEGORY] integerValue]
                                                             closedURL:[temp objectForKey:k_CLOSED_URL]
                                                                avatar:[temp objectForKey:k_AVATAR]
                                                            video_link:[temp objectForKey:k_VIDEOLINK]
                                                                  gift:[temp objectForKey:k_GIFTLINK]
                                                                  logo:[temp objectForKey:@"logo"]
                                                        countryAvatars:[temp objectForKey:k_COUNTRY_AVATAR]
                                                                   gsb:[[temp objectForKey:@"gsb"] integerValue]
													  topBannerArticle:[temp objectForKey:@"top_banner_article"]
														 topBannerLink:[temp objectForKey:@"top_banner_link"]];

                switch (newrace.category) {
                    case 1:
                        [countryRaces addObject:newrace];
                        break;
                    case 2:
                        [locationRaces addObject:newrace];
                        break;
                    case 3:
                        [themedRaces addObject:newrace];
                        break;
                    case 4:
                        [sponsoredRaces addObject:newrace];
                        break;
                    case 5:
                        [exclusiveRaces addObject:newrace];
                        break;
                }
            }
        }
        
        [racesByCategory setObject:countryRaces forKey:[categoryList objectAtIndex:0]];
        [racesByCategory setObject:locationRaces forKey:[categoryList objectAtIndex:1]];
        [racesByCategory setObject:themedRaces forKey:[categoryList objectAtIndex:2]];
        [racesByCategory setObject:sponsoredRaces forKey:[categoryList objectAtIndex:3]];
        [racesByCategory setObject:exclusiveRaces forKey:[categoryList objectAtIndex:4]];
    }
    return self;
}

@end
