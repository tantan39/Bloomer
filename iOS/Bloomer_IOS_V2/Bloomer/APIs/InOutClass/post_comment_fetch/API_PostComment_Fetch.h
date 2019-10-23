//
//  API_PostComment_Fetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_post_comment_fetch.h"
@interface API_PostComment_Fetch : BloomerRestful
-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token post_id:(NSString*)post_id comment_id:(NSString *)comment_id;

@end
