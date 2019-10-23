//
//  API_Races_BannerFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Races_BannerFetches.h"

@implementation API_Races_BannerFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token gender:(NSInteger)gender key:(NSString *)key cKey:(NSString *)cKey{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_GENDER : [NSNumber numberWithInteger:gender],
                              k_KEY : key,
                              k_CKEY : cKey};
    
    self = [super initWith:[APIDefine race_banner_fetchesLink] Params:params];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    if (json) {
        return (BaseJSON *)[[JSON_BannerFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_BannerFetch alloc] init];
}

@end
