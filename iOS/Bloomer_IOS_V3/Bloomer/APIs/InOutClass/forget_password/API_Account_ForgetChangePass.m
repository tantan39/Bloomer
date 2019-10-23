//
//  API_Account_ForgetChangePass.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Account_ForgetChangePass.h"

@implementation API_Account_ForgetChangePass

- (instancetype)initWithParams:(account_forget_changepass *)params{
    self = [super initWith:[APIDefine account_forget_changepassLink] Params:[params encodeToJSON]];
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
