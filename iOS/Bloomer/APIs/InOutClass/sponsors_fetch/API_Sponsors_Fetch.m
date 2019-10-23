//
//  API_Sponsors_Fetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Sponsors_Fetch.h"

@implementation API_Sponsors_Fetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token user_id:(NSInteger)user_id{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(user_id).stringValue
                              };
    self = [super initWith:[APIDefine sponsor_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_sponsor_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_sponsor_fetch alloc] init];
}

@end
