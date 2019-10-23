//
//  Anonymous_Profile_BannerFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_Profile_BannerFetches.h"

@implementation API_Anonymous_Profile_BannerFetches

- (instancetype)initWithUid:(NSInteger)uid{
    
    NSDictionary * params = @{k_USER_ID : [NSNumber numberWithInteger:uid]};
    
    self = [super initWith:[APIDefine anonymous_profile_bannerLink] Params:params];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[JSON_BannerFetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[JSON_BannerFetch alloc] init];
}

@end
