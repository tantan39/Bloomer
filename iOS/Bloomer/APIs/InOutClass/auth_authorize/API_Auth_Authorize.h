//
//  API_Auth_Authorize.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "auth_authorize.h"
#import "out_auth_authorize.h"
#import "APIDefine.h"

@interface API_Auth_Authorize : BloomerRestful

- (instancetype) initWithParams:(auth_authorize * ) authThorize;
- (instancetype) initWithParams:(auth_authorize * ) authThorize viaCode:(BOOL)use_code;

@end
