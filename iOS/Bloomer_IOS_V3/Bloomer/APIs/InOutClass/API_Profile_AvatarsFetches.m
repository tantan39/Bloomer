//
//  API_Profile_AvatarsFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_AvatarsFetches.h"

@implementation API_Profile_AvatarsFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:[APIDefine profile_avatarsLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_avatars_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_avatars_fetches alloc] init];
}

@end
