//
//  API_Auth_FBRegister.m
//  Bloomer
//
//  Created by Le Chau Tu on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_FBRegister.h"

@implementation API_Auth_FBRegister

-(id)initWithParams:(Auth_FBRegisterParams *)params {
    self = [super initWith:[APIDefine FBRegisterLink] Params:[params encodeToJSON]];
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
