//
//  out_auth_authorize.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_auth_authorize.h"

@implementation out_auth_authorize

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        
//        _verified = [[json objectForKey:k_VERIFIED] boolValue];
        
        NSDictionary *user = [json objectForKey:k_USER];
        _uid = [[user objectForKey:k_UID] integerValue];
        _screen_name = [user objectForKey:k_SCREEN_NAME];
        _num_flower = [[user objectForKey:k_FLOWER] longLongValue];
        _gender = [[user objectForKey:k_GENDER] integerValue];
        _number_chatting = [[user objectForKey:k_NUMBER_CHATTING] integerValue];
        _avatar_url = [user objectForKey:k_AVATAR];
        _is_exist_email = [[json objectForKey:k_EXIST_MAIL_FB] boolValue];
        
        NSDictionary *auth = [json objectForKey:k_AUTH];
//        _expire_time = [[auth objectForKey:k_EXPIRED_TIME] integerValue];
        _refresh_token = [auth objectForKey:k_REFRESH_TOKEN];
        _cridential_ejab = [auth objectForKey:k_CRIDENTIAL_EJAB];
        _access_token = [auth objectForKey:k_ACCESS_TOKEN];
        _mobile = [auth objectForKey:k_MOBILE_FB];

    }
    return self;
}


@end
