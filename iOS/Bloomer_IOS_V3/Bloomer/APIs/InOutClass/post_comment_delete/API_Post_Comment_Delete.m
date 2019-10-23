//
//  API_Post_Comment_Delete.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Post_Comment_Delete.h"

@implementation API_Post_Comment_Delete

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id comment_id:(NSString *)comment_id{

    NSDictionary * params = @{
                              k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id,
                              k_COMMENT_ID : comment_id
                              };
    self = [super initWith:[APIDefine post_comment_deleteLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json {
    return nil;
}

@end
