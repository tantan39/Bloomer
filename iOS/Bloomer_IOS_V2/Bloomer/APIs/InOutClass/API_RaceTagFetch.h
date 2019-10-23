//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "JSON_RaceTagsFetch.h"

@interface API_RaceTagFetch : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token;

@end
