//
//  API_Account_ForgetChangePass.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "account_forget_changepass.h"
#import "out_auth_register_verifycode.h"

@interface API_Account_ForgetChangePass : BloomerRestful

- (instancetype)initWithParams:(account_forget_changepass *) params;

@end
