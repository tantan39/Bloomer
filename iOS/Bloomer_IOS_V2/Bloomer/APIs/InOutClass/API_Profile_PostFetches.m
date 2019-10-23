//
//  API_Profile_PostFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_PostFetches.h"

@implementation API_Profile_PostFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid post_id:(NSString *)post_id{
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(uid).stringValue,
                              k_POST_ID : post_id};
    
    self = [super initWith:[APIDefine profile_postLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_profile_post_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_profile_post_fetches alloc] init];
}

@end
