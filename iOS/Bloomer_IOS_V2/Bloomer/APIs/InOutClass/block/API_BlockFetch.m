//
//  API_BlockFetch.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_BlockFetch.h"

@implementation API_BlockFetch

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token
                              };
    self = [super initWith:[APIDefine block_fetchLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_block_fetch alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_block_fetch alloc] init];
}
@end
