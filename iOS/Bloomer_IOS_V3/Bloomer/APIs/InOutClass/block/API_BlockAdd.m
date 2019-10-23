//
//  API_BlockAdd.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_BlockAdd.h"

@implementation API_BlockAdd

- (instancetype)initWithParams:(out_auth_register_verifycode *)params{
    self = [super initWith:[APIDefine profile_Block_Link] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_auth_register_verifycode * model;
    if (json) {
        model = [[out_auth_register_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *)model;
}

@end
