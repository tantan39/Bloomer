//
//  API_ProfileFetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "out_profile_fetch.h"
@interface API_ProfileFetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
               andUserId:(NSString *)uid;
@end
