//
//  API_Feeds.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_FeedList.h"

@interface API_Feeds : BloomerRestful

-(id)initWithAccessToken:(NSString*)access_token deviceId:(NSString*)device_id feedId:(NSString*)feed_id;
-(id)initWithFeedId:(NSString*)feed_id;

@end
