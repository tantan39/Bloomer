//
//  API_Auth_Register.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "auth_register.h"
#import "out_auth_authorize.h"

@interface API_Auth_Register : BloomerRestful

- (instancetype) initWithParams:(auth_register * ) authRegister;

@end
