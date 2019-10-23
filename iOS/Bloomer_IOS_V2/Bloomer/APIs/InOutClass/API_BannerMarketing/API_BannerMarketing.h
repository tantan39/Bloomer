//
//  API_BannerMarketing.h
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "Json_BannerMarketing.h"

@interface API_BannerMarketing : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token;

-(instancetype)init;
@end
