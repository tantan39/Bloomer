//
//  API_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PostUserFetches.h"

#define DEFAULT_LIMIT 4

@implementation API_PostUserFetches

// device_id=...&post_id=...&user_id=...&limit=...

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   postID:(NSString *)post_id uid:(NSInteger)uid {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_POST_ID: post_id,
                             k_USER_ID: @(uid).stringValue,
                             k_LIMIT: @(DEFAULT_LIMIT).stringValue
                             };
    self = [super initWith:[APIDefine post_user_fetchesLink] Params:params];
    return self;
}

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   postID:(NSString *)post_id uid:(NSInteger)uid limit:(NSInteger)limit {
    NSDictionary *params = @{
                             k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token,
                             k_POST_ID: post_id,
                             k_USER_ID: @(uid).stringValue,
                             k_LIMIT: @(limit).stringValue
                             };
    self = [super initWith:[APIDefine post_user_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_PostUserFetches *model;
    if (json) {
        model = [[JSON_PostUserFetches alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
