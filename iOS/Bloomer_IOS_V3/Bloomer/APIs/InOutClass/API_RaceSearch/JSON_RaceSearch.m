//
//  JSON_RaceSearch.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_RaceSearch.h"

@implementation JSON_RaceSearch
@synthesize searchList;

-(instancetype)initWithJSON:(NSDictionary *)data {
    self = [super init];
    if(self) {
        NSArray *output = [data objectForKey:k_RACES];
        searchList = [[NSMutableArray alloc] init];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i < n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            NSString* video_link = [temp objectForKey:@"video"];
            if(video_link == nil) video_link = @"";
            
            RacesObj *newRace = [[RacesObj alloc] initWithName:[temp objectForKey:k_NAME]
                                                     uid:[[temp objectForKey:k_UID] integerValue]
                                                username:[temp objectForKey:k_USERNAME]
                                                  flower:[[temp objectForKey:k_FLOWER] longLongValue]
                                                    rank:[[temp objectForKey:k_RANK] integerValue]
                                                  avatar:[temp objectForKey:k_AVATAR]
                                                  moCode:[temp objectForKey:@"moCode"]
                                                  spCode:[temp objectForKey:@"spCode"]
                                                 aboutme:[temp objectForKey:@"aboutme"]
                                              video_link:video_link
                                                gsbMedal:[temp objectForKey:@"gsb_medal"]];
            newRace.is_icon = [[temp objectForKey:@"is_icon"] boolValue];
            [searchList addObject:newRace];
        }
    }
    return self;
}

@end
