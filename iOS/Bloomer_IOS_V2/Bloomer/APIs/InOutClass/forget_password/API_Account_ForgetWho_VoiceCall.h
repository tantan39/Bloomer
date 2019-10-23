//
//  API_Account_ForgetWho_VoiceCall.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "account_forget_who.h"
#import "out_account_forget_who.h"
@interface API_Account_ForgetWho_VoiceCall : BloomerRestful

- (instancetype)initWithParams:(account_forget_who *) params;

@end
