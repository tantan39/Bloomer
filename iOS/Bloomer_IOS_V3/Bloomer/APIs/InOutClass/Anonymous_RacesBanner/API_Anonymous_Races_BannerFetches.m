//
//  API_Anonymous_Races_BannerFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_Races_BannerFetches.h"

@implementation API_Anonymous_Races_BannerFetches
//return [[self getrootURL] stringByAppendingString:@"takeatour/race.banner.load?gender=...&key=...&ckey=...&is_refresh=..."];
- (instancetype)initWithGender:(NSInteger)gender key:(NSString *)key cKey:(NSString *)cKey{
    NSDictionary * params = @{k_GENDER : [NSNumber numberWithInteger:gender],
                            k_KEY : key,
                            k_CKEY : cKey};
    
    self = [super initWith:[APIDefine anonymous_race_banner_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[JSON_BannerFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[JSON_BannerFetch alloc] init];
}

@end
