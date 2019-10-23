//
//  API_Content_Post_Fetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Content_Post_Fetches.h"

@implementation API_Content_Post_Fetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id{
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id
                              };
    self = [super initWith:[APIDefine content_post_fetchesLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_content_post alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_content_post alloc] init];
}

@end
