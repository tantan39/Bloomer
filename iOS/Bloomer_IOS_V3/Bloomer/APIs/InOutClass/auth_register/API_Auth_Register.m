//
//  API_Auth_Register.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_Register.h"

@implementation API_Auth_Register

- (instancetype)initWithParams:(auth_register *)authRegister{

    self = [super initWith:[APIDefine auth_registerLink] Params: [authRegister encodeToJSON]];
    return self;
    
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_authorize * model;
    
    if (json) {
        model = [[out_auth_authorize alloc] initWithJSON:json];
    }
    
    return (BaseJSON *)model;
}

@end
