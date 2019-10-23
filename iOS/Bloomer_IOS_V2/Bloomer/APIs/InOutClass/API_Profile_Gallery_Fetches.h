//
//  API_Profile_Gallery_Fetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_profile_gallery_fetches.h"

@interface API_Profile_Gallery_Fetches : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                      uid:(NSInteger)uid;

@end
