//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_AnonymousRaceName.h"

@implementation API_AnonymousRaceName

- (id)initWithKey:(NSString *)key gender:(NSInteger)gender {
    NSDictionary *params = @{
                             k_KEY: key,
                             k_GENDER: @(gender).stringValue
                             };
    self = [super initWith:[APIDefine anonymous_race_name_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_RacesNameFetch *model;
    if (json) {
        model = [[JSON_RacesNameFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
