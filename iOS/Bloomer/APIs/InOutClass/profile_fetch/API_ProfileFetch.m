//
//  API_ProfileFetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_ProfileFetch.h"

@implementation API_ProfileFetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token andUserId:(NSString *)uid{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : uid};
    
    self = [super initWith:[APIDefine profile_New_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_profile_fetch * model;
    if (json) {
        model = [[out_profile_fetch alloc] initWithJSON:json];
    }
    
    return (BaseJSON *)model;
}

@end
