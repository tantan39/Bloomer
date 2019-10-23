//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_PostUserFetches.h"

@interface API_PostUserFetches : BloomerRestful

@property (assign, nonatomic) NSInteger userID;

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   postID:(NSString *)post_id uid:(NSInteger)uid limit:(NSInteger)limit;

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                   postID:(NSString *)post_id uid:(NSInteger)uid;

@end
