//
//  API_Content_Post_Fetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_content_post.h"

@interface API_Content_Post_Fetches : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                  post_id:(NSString *)post_id;

@end
