//
//  API_GetFeed.m
//  Bloomer
//
//  Created by Tan Tan on 8/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_GetFeed.h"

@implementation API_GetFeed

- (instancetype)initWithAccessToken:(NSString *)accessToken DeviceToken:(NSString *)deviceToken FeedID:(NSString *)feedId{

    NSDictionary * json = @{ k_ACCESS_TOKEN : accessToken,
                             k_DEVICE_TOKEN : deviceToken,
                             k_FEED_ID : feedId };
    
    self = [super initWith:[APIDefine get_FeedLink] Params:json];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_GetFeed alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_GetFeed alloc] init];
    
}
@end
