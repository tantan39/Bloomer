//
//  API_Post_Delete.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Post_Delete.h"

@implementation API_Post_Delete

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token post_id:(NSString *)post_id{
//    access_token=..&device_id=...&post_id=...
    NSDictionary * params = @{
                              k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_POST_ID : post_id
                              };
    self = [super initWith:[APIDefine post_deleteLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_account_forget_verifycode * model = [[out_account_forget_verifycode alloc] init];
    if (json) {
        model = [[out_account_forget_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
