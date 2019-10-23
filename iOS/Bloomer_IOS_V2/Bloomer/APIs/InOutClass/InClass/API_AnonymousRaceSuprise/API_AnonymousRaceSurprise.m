//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_AnonymousRaceSurprise.h"

@implementation API_AnonymousRaceSurprise

- (id)initWithKey:(NSString *)key ckey:(NSString *)ckey gender:(NSInteger)gender {
    
    NSDictionary *params = @{
                             k_KEY: key,
                             k_CKEY: ckey,
                             k_GENDER: @(gender).stringValue
                             };
    self = [super initWith:[APIDefine anonymous_races_surprise_fetchesLink] Params:params];
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
