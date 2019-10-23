//
//  API_Auth_ResendCode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 12/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "resendcode.h"
#import "out_auth_register_sendcode.h"
@interface API_Auth_ResendCode : BloomerRestful

- (instancetype)initWithParamsForSignUp:(resendcode *) params;
- (instancetype)initWithParamsForUpdate:(resendcode *) params;
- (instancetype)initWithParamsForLogin:(resendcode *) params;

@end
