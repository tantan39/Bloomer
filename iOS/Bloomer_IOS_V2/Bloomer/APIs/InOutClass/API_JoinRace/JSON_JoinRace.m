//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_JoinRace.h"

@implementation JSON_JoinRace

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        if (json[k_CONTENT] != [NSNull null]) {
            self.content = json[k_CONTENT];
        }
        if (json[k_iRACE_JOINED] != [NSNull null]) {
            self.irace_joined = [json[k_iRACE_JOINED] integerValue];
        }
        if (json[k_iRACE_NEW] != [NSNull null]) {
            self.irace_new = [json[k_iRACE_NEW] integerValue];
        }
    }
    return self;
}

@end


@implementation JSON_CheckJoinRace

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        if (json[k_CONTENT] != [NSNull null]) {
            self.content = json[k_CONTENT];
        }
        if (json[k_IS_JOIN] != [NSNull null]) {
            self.irace_joined = [json[k_IS_JOIN] integerValue];
        }
        if (json[k_IS_LEAVE] != [NSNull null]) {
            self.irace_left = [json[k_IS_LEAVE] integerValue];
        }
    }
    return self;
}

@end
