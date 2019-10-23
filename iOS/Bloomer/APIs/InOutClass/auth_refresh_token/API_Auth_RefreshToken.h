//
//  API_Auth_RefreshToken.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "auth_refresh_token.h"
#import "out_auth_refresh_token.h"
@interface API_Auth_RefreshToken : BloomerRestful

- (instancetype)initWithParams:(auth_refresh_token *) params;

@end
