//
//  API_IsChat_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_IsChat_Fetch.h"

@implementation API_IsChat_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token andUserId:(NSString *)uid{
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : uid
                              };
    self = [super initWith:[APIDefine isChat_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_is_chat_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_is_chat_fetch alloc] init];
}
@end
