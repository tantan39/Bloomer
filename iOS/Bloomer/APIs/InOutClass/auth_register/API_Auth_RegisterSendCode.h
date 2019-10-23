//
//  API_Auth_RegisterSendCode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "sendcode.h"
#import "out_auth_register_sendcode.h"
@interface API_Auth_RegisterSendCode : BloomerRestful

- (instancetype)initWithParams:(sendcode *) params;

@end
