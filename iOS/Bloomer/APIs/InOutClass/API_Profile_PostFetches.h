//
//  API_Profile_PostFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_profile_post_fetches.h"
@interface API_Profile_PostFetches : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                      uid:(NSInteger)uid
                  post_id:(NSString *)post_id;

@end
