//
//  API_Discovery_Fetches.h
//  Bloomer
//
//  Created by Ahri on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_DiscoveryFetches.h"

@interface API_DiscoveryFetches : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                   gender:(NSInteger)gender
               is_refresh:(BOOL)is_refresh
                      uid:(NSInteger)uid;

- (instancetype)initWithGender:(NSInteger)gender
                          city:(NSString *)city
                    is_refresh:(BOOL)is_refresh
                           uid:(NSInteger)uid;

@end
