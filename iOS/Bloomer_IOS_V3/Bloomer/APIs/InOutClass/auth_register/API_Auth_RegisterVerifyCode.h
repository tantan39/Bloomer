//
//  API_Auth_RegisterVerifyCode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "verifycode.h"
#import "out_auth_register_verifycode.h"
@interface API_Auth_RegisterVerifyCode : BloomerRestful

- (instancetype)initWithParams:(verifycode *) params;

@end
