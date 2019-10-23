//
//  API_Auth_FBRegister.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "Auth_FBRegisterParams.h"
#import "out_auth_authorize.h"

@interface API_Auth_FBRegister : BloomerRestful

-(id)initWithParams:(Auth_FBRegisterParams*)params;

@end
