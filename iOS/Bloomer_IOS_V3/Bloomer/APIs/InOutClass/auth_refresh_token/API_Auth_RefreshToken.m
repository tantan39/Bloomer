//
//  API_Auth_RefreshToken.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_RefreshToken.h"

@implementation API_Auth_RefreshToken

- (instancetype)initWithParams:(auth_refresh_token *)params{
    self = [super initWith:[APIDefine refresh_tokenLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_refresh_token * model;
    if (json) {
        model = [[out_auth_refresh_token alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
