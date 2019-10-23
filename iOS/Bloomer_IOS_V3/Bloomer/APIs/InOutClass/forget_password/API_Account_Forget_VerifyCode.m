//
//  API_Account_Forget_VerifyCode.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Account_Forget_VerifyCode.h"

@implementation API_Account_Forget_VerifyCode

- (instancetype)initWithParams:(account_forget_verifycode *)params{
    self = [super initWith:[APIDefine account_forget_verifycodeLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    out_account_forget_verifycode * model = [[out_account_forget_verifycode alloc] init];
    if (json) {
        model = [[out_account_forget_verifycode alloc] initWithJSON:json];
    }
    return (BaseJSON *) model;
}

@end
