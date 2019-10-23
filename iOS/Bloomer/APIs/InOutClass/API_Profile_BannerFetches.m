//
//  API_Profile_BannerFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_BannerFetches.h"

@implementation API_Profile_BannerFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid{
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : [NSNumber numberWithInteger:uid]};
    
    self = [super initWith:[APIDefine profile_bannerLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[JSON_BannerFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[JSON_BannerFetch alloc] init];
}

@end
