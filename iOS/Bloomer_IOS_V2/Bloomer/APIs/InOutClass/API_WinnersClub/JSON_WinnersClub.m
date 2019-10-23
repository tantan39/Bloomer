//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_WinnersClub.h"

@implementation JSON_WinnersClub

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.winners = [[NSMutableArray alloc] init];
        
        NSArray *winnersJSON = json[k_WINNERS];
        for (int i = 0; i < winnersJSON.count; i++) {
            WinnerObj *obj = [[WinnerObj alloc] init];
            
            obj.uid = [winnersJSON[i][k_UID] integerValue];
            obj.name = winnersJSON[i][k_NAME];
            obj.username = winnersJSON[i][k_USERNAME];
            obj.gsb_medal = winnersJSON[i][k_GSB_MEDAL];
            obj.avatar = winnersJSON[i][k_AVATAR];
            obj.flower = [winnersJSON[i][k_FLOWER] integerValue];
            obj.video = winnersJSON[i][k_VIDEO];
            obj.is_icon = [winnersJSON[i][@"is_icon"] boolValue];
            
            [self.winners addObject:obj];
        }
    }
    return self;
}

@end
