//
//  API_UserRacePosts.m
//  Bloomer
//
//  Created by Steven on 4/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_UserRacePosts.h"

@implementation API_UserRacePosts

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token key:(NSString *)key uid:(NSInteger)uid post_id:(NSString *)post_id  limit:(NSInteger)limit{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_KEY : key,
                              k_USER_ID : @(uid).stringValue,
                              k_POST_ID : post_id,
                              k_LIMIT : @(limit).stringValue
                              };
    self = [super initWith:[APIDefine user_race_posts_link] Params:params];
    _raceKey = key;

    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_UserRacePosts alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_UserRacePosts alloc] init];
}

@end
