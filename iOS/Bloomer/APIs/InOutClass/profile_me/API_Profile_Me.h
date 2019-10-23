//
//  API_Profile_Me.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_profile_fetch.h"
#import "APIDefine.h"
@interface API_Profile_Me : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

@end
