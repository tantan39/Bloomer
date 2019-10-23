//
//  API_PostComment_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PostComment_Fetch.h"

@implementation API_PostComment_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id comment_id:(NSString *)comment_id{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id,
                              k_COMMENT_ID: comment_id
                              };
    self = [super initWith:[APIDefine post_comments_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_post_comment_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_post_comment_fetch alloc] init];
}

@end
