//
//  API_FaceUser.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_faces.h"

@interface API_FaceUser : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                 user_id:(NSString *) userid
                     min:(NSInteger)minValue
                     max:(NSInteger)maxValue
                  postID:(NSString *) postid
                order_by:(NSString *)order_by;
@end
