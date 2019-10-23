//
//  API_Profile_SettingFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_profile_setting.h"

@interface API_Profile_SettingFetches : BloomerRestful
-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token;

@end
