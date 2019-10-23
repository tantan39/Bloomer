//
//  API_Feeds.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Feeds.h"

@implementation API_Feeds

-(id)initWithAccessToken:(NSString *)access_token deviceId:(NSString *)device_id feedId:(NSString *)feed_id {
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_id,
                             k_FEED_ID: feed_id};
    self = [super initWith:[APIDefine user_feed_fetchesLink] Params:params];
    return self;
}

-(id)initWithFeedId:(NSString *)feed_id {
    NSDictionary *params = @{k_FEED_ID: feed_id};
    self = [super initWith:[APIDefine anonymous_feedLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_FeedList* model;
    if (json) {
        model = [[JSON_FeedList alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
