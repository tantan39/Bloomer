//
//  API_Auth_RegisterInfo.m
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "API_Auth_RegisterInfo.h"

@implementation API_Auth_RegisterInfo

- (instancetype)initWithRegisterInfo:(RegisterInfo *)info{
    
    self = [super initWith:[APIDefine auth_registerInfoLink] Params:[info encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_Auth_RegisterInfo alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_Auth_RegisterInfo alloc] init];
}
@end
