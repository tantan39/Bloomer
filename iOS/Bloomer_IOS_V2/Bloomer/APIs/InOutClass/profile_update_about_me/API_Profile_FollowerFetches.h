//
//  API_Profile_FollowerFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_follower_fetches.h"

@interface API_Profile_FollowerFetches : BloomerRestful

@property (assign, nonatomic) BOOL isLoadMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  userID:(NSInteger)uid
                   limit:(NSInteger)limit
              isLoadMore:(BOOL)isMore;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                  userID:(NSInteger)uid
                   limit:(NSInteger)limit;

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                   limit:(NSInteger)limit;

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token limit:(NSInteger)limit sort:(NSString*)sort;
- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid limit:(NSInteger)limit sort:(NSString*)sort;

@end
