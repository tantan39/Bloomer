//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_AnonymousRace.h"

@implementation API_AnonymousRace

- (id)initWithKey:(NSString *)key ckey:(NSString *)ckey
             rank:(NSInteger)rank isRefresh:(BOOL)isRefresh gender:(NSInteger)gender {
    NSDictionary *params = @{
                             k_KEY: key,
                             k_RANK: @(rank).stringValue,
                             k_IS_REFRESH: isRefresh? @"true" : @"false",
                             k_GENDER: @(gender).stringValue,
                             k_CKEY: ckey
                             };
    self = [super initWith:[APIDefine anonymous_race_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RacesFetch *model;
    if (json) {
        model = [[JSON_RacesFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
