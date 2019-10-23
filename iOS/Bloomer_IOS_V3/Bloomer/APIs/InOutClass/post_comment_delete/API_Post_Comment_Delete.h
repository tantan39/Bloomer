//
//  API_Post_Comment_Delete.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@interface API_Post_Comment_Delete : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token post_id:(NSString*)post_id comment_id:(NSString*)comment_id;

@end
