//
//  API_Auth_RegisterCallSupport.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Auth_RegisterCallSupport.h"

@implementation API_Auth_RegisterCallSupport

- (instancetype)initWithParams:(sendcode *)params{
    self = [super initWith:[APIDefine auth_register_callsupportlink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    sendcode * model;
    //    if (json) {
    model = [[sendcode alloc]init];
    //    }
    
    return (BaseJSON*) model;
}

@end
