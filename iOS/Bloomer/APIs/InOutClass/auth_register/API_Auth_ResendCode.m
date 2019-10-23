//
//  API_Auth_ResendCode.m
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_ResendCode.h"
#import "resendcode.h"

@implementation API_Auth_ResendCode

-(instancetype)initWithParamsForLogin:(resendcode *)params {
    self = [super initWith:[APIDefine auth_resendcodeLoginLink] Params:[params encodeToJSON]];
    return self;
}

-(instancetype)initWithParamsForSignUp:(resendcode *)params {
    self = [super initWith:[APIDefine auth_resendcodeLink] Params:[params encodeToJSON]];
    return self;
}

-(instancetype)initWithParamsForUpdate:(resendcode *)params {
    self = [super initWith:[APIDefine auth_resendcodeUpdateLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_register_sendcode * model;
    if (json) {
        model = [[out_auth_register_sendcode alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
