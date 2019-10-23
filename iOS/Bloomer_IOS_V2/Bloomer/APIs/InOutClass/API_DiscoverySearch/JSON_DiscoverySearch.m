//
//  JSON_DiscoverySearch.m
//  Bloomer
//
//  Created by Ahri on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_DiscoverySearch.h"

@implementation JSON_DiscoverySearch

- (instancetype) initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *discoveriesJSON = [json objectForKey:k_DISCOVERY_RESULT];
        self.searchList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < discoveriesJSON.count; i++) {
            NSDictionary *temp = discoveriesJSON[i];
            //        NSData *nameData = [temp[k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
            //        NSString* _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
            
            RacesObj *newRace = [[RacesObj alloc] initWithName:/*_name*/temp[k_NAME]
                                                     uid:[temp[k_UID] integerValue]
                                                username:temp[k_USERNAME]
                                                  flower:[temp[k_FLOWER] longLongValue]
                                                    rank:[temp[k_RANK] integerValue]
                                                  avatar:temp[k_AVATAR]
                                                  moCode:temp[@"moCode"]
                                                  spCode:temp[@"spCode"]
                                                 aboutme:temp[@"aboutme"]
                                              video_link:temp[@"video_link"]
                                                gsbMedal:temp[@"gsb_medal"]];
            [self.searchList addObject:newRace];
        }
    }
    
    return self;
}

@end
