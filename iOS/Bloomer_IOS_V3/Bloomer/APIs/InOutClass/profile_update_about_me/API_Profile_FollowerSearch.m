//
//  API_Profile_Follower_Search.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_FollowerSearch.h"

@implementation API_Profile_FollowerSearch

//access_token=...&device_id=...&term_search=

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token term_search:(NSString *)termSearch{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_TERMSEARCH : termSearch};
    
    self = [super initWith:[APIDefine profile_searchFllower] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_follower_search alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_follower_search alloc] init];
}

@end
