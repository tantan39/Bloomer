//
//  API_Profile_Post_GalleryFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_GalleryFetches.h"

@interface API_Profile_Post_GalleryFetches : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                     uid:(NSInteger)uid
                 post_id:(NSString *)post_id
                   limit:(NSInteger)limit;

@end
