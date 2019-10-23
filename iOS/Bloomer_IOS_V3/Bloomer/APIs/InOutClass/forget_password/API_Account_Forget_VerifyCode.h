//
//  API_Account_Forget_VerifyCode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "account_forget_verifycode.h"
#import "out_account_forget_verifycode.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface API_Account_Forget_VerifyCode : BloomerRestful

- (instancetype)initWithParams:(account_forget_verifycode *) params;

@end
