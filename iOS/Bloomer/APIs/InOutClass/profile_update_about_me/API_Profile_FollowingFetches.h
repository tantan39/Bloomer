//
//  API_Profile_FollowingFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_following_fetches.h"
#import "BaseJSON.h"

@interface API_Profile_FollowingFetches : BloomerRestful

@property (assign, nonatomic) BOOL isLoadMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  userID:(NSInteger)uid
                   limit:(NSInteger)limit
              isLoadMore:(BOOL)isMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  userID:(NSInteger)uid;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token;

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token limit:(NSInteger)limit sort:(NSString*)sort;
- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid limit:(NSInteger)limit sort:(NSString*)sort;

@end
