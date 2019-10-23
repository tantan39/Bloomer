//
//  API_Auth_FBAuthentication.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/30/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "Auth_FBAuthentication.h"
#import "out_auth_authorize.h"
@interface API_Auth_FBAuthentication : BloomerRestful

- (instancetype)initWithParams:(Auth_FBAuthentication *) params;

@end
