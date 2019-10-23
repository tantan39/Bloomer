//
//  API_Races_GalleryFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_GalleryFetches.h"

@interface API_Races_GalleryFetches : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
                       device_token:(NSString *)device_token
                                key:(NSString *)key
                             gender:(NSInteger)gender
                            post_id:(NSString *)post_id
                              limit:(NSInteger)limit;

@end
