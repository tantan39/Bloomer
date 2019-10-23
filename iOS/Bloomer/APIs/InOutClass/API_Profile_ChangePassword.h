//
//  API_Profile_ChangePassword.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "password.h"
#import "out_name_update.h"
@interface API_Profile_ChangePassword : BloomerRestful

- (instancetype)initWithParams:(password *) params;

@end
