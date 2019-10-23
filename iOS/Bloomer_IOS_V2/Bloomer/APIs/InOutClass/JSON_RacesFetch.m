//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_RacesFetch.h"

@implementation JSON_RacesFetch

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        if (json[k_MY_RANK] == nil) {
            self.myrank = -1;
        } else {
            self.myrank = [json[k_MY_RANK] integerValue];
        }
        NSArray *racesJSON = json[k_RACES];
        self.racesList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < racesJSON.count; i++) {
            NSDictionary *raceJSON = racesJSON[i];
            
            //        NSData *nameData = [temp[k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
            //        NSString* _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
            
            RacesObj *newRace = [[RacesObj alloc] initWithName:/*_name*/raceJSON[k_NAME]
                                                           uid:[raceJSON[k_UID] integerValue]
                                                      username:raceJSON[k_USERNAME]
                                                        flower:[raceJSON[k_FLOWER] longLongValue]
                                                          rank:[raceJSON[k_RANK] integerValue]
                                                        avatar:raceJSON[k_AVATAR]
                                                        moCode:raceJSON[k_MOCODE_UPPER_C]
                                                        spCode:raceJSON[k_SPCODE_UPPER_C]
                                                       aboutme:raceJSON[k_ABOUT_ME2]
                                                    video_link:raceJSON[k_VIDEO] == nil ? @"" : raceJSON[k_VIDEO]
                                                      gsbMedal:raceJSON[k_GSB_MEDAL]];
            newRace.is_icon = [raceJSON[@"is_icon"] boolValue];
            [self.racesList addObject:newRace];
        }
        
    }
    return self;
}

@end
