//
//  API_Auth_Expired.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_Auth_Expired.h"

@interface API_Auth_Expired : BloomerRestful
-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

@end
