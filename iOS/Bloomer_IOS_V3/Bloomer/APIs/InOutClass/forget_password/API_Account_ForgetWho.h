//
//  API_Account_ForgetWho.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "account_forget_who.h"
#import "out_account_forget_who.h"
#import "BaseJSON.h"
#import "APIDefine.h"
@interface API_Account_ForgetWho : BloomerRestful

-(instancetype)initWithParams:(account_forget_who *)data;

@end
