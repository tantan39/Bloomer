//
//  API_BlockLists_Fetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_BlockLists_Fetches.h"

@implementation API_BlockLists_Fetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token};
    
    self = [super initWith:[APIDefine profile_fetchBlockerLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_blocklists_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_blocklists_fetches alloc] init];
}


@end
