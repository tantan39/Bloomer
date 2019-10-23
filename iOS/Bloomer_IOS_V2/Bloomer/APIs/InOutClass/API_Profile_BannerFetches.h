//
//  API_Profile_BannerFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "JSON_BannerFetch.h"

@interface API_Profile_BannerFetches : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     uid:(NSInteger)uid;

@end
