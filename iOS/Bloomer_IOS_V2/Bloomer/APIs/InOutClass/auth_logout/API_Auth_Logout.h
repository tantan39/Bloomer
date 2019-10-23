//
//  API_Auth_Logout.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/25/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_auth_logout.h"

@interface API_Auth_Logout : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

@end
