//
//  API_Profile_Setting.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_profile_fetch.h"

@interface API_Profile_Setting : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

@end
