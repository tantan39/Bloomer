//
//  API_Post_FollowerFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Post_FollowerFetches.h"

@implementation API_Post_FollowerFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token postID:(NSString *)post_id index:(NSInteger)index{
//    access_token=...&device_id=...&post_id=...&index=...
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id,
                              k_INDEX : @(index).stringValue};
    self = [super initWith:[APIDefine post_followers_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_follower_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_follower_fetches alloc] init];
}

@end
