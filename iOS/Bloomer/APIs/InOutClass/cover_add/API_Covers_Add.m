//
//  API_Covers_Add.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Covers_Add.h"

@implementation API_Covers_Add

- (instancetype)initWithParams:(covers_add *)params{
    self = [super initWith:[APIDefine covers_addLink] Params:[params encodeToJSON]];
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
