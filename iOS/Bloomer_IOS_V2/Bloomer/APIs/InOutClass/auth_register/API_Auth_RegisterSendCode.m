//
//  API_Auth_RegisterSendCode.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_RegisterSendCode.h"

@implementation API_Auth_RegisterSendCode

- (instancetype)initWithParams:(sendcode *)params{
    self = [super initWith:[APIDefine auth_register_sendcodeLink] Params:[params encodeToJSON]];
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
