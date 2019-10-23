//
//  API_Message_RefreshToken.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Message_RefreshToken.h"

@implementation API_Message_RefreshToken

- (instancetype)initWithAddressLink:(NSString *)address_link access_token:(NSString *)access_token device_token:(NSString *)device_token{
    
    RequestURL * url = [[RequestURL alloc] initWithURL:@"" Host:address_link requestMethod:GET];

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:url Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_message_refresh_token alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_message_refresh_token alloc] init];
}

@end
