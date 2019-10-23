//
//  API_BannerMarketing.m
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_BannerMarketing.h"

@implementation API_BannerMarketing

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token};
    self = [self initWith:[APIDefine getBannerMarketing] Params:params];
    
    return self;
}

-(id)init {
    self = [self initWith:[APIDefine getAnonymousBannerMarketing] Params:nil];
    
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    Json_BannerMarketing *model;
    if (json) {
        model = [[Json_BannerMarketing alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
