//
//  API_Profile_FollowingSearch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_FollowingSearch.h"

@implementation API_Profile_FollowingSearch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token termSearch:(NSString *)term_seach{
//    access_token=...&device_id=...&term_search=...
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_TERMSEARCH : term_seach};
    
    self = [super initWith:[APIDefine profile_searchFllowing] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_following_search alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_following_search alloc] init];
}

@end
