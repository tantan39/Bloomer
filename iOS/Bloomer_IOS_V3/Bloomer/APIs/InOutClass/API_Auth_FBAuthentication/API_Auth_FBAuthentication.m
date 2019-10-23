//
//  API_Auth_FBAuthentication.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_FBAuthentication.h"

@implementation API_Auth_FBAuthentication

- (instancetype)initWithParams:(Auth_FBAuthentication *)params{
    
    self = [super initWith:[APIDefine FBAuthenticationLink] Params:[params encodeToJSON]];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_auth_authorize alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_auth_authorize alloc] init];
}

@end
