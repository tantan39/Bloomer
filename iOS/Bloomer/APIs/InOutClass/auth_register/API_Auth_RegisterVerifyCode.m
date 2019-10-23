//
//  API_Auth_RegisterVerifyCode.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_RegisterVerifyCode.h"

@implementation API_Auth_RegisterVerifyCode

- (instancetype)initWithParams:(verifycode *)params{
    self = [super initWith:[APIDefine auth_register_verifycodeLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_register_verifycode * model;
    if (json) {
        model = [[out_auth_register_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *) model;
}

@end
