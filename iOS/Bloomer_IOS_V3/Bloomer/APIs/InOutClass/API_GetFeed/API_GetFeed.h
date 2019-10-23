//
//  API_GetFeed.h
//  Bloomer
//
//  Created by Tan Tan on 8/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_GetFeed.h"
@interface API_GetFeed : BloomerRestful

- (instancetype) initWithAccessToken:(NSString *) accessToken DeviceToken:(NSString *) deviceToken FeedID:(NSString *) feedId;

@end
