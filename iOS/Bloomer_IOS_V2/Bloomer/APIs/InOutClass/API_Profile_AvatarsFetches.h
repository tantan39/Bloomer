//
//  API_Profile_AvatarsFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_avatars_fetches.h"
@interface API_Profile_AvatarsFetches : BloomerRestful
- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token;
@end
