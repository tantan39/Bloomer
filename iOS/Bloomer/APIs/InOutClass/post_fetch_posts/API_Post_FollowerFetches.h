//
//  API_Post_FollowerFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_follower_fetches.h"
#import "BaseJSON.h"

@interface API_Post_FollowerFetches : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  postID:(NSString *)post_id
                   index:(NSInteger)index;

@end
