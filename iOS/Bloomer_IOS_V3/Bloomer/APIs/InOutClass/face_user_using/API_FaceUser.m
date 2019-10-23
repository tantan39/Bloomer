//
//  API_FaceUser.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_FaceUser.h"

@implementation API_FaceUser

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token user_id:(NSString *)userid min:(NSInteger)minValue max:(NSInteger)maxValue postID:(NSString *)postid order_by:(NSString *)order_by{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : userid,
                              k_MIN : [NSString stringWithFormat:@"%ld", (long)minValue],
                              k_MAX : [NSString stringWithFormat:@"%ld", (long)maxValue],
                              k_POST_ID : postid,
                              k_OrderBy : order_by
                              };
    
    self = [super initWith:[APIDefine post_fetch_posts_userLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    if (json) {
        return  (BaseJSON *)[[out_faces alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_faces alloc] init];
}

@end
