//
//  API_Profile_FollowingFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_FollowingFetches.h"

@implementation API_Profile_FollowingFetches

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token userID:(NSInteger)uid limit:(NSInteger)limit isLoadMore:(BOOL)isMore{
    self.isLoadMore = isMore;
    
    if(self.isLoadMore){
        return [self initWithAccessToken:access_token device_token:device_token userID:uid limit:limit];
    } else {
        return [self initWithAccessToken:access_token device_token:device_token userID:-1 limit:limit];
    }
}

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token userID:(NSInteger)uid limit:(NSInteger)limit{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(uid).stringValue,
                              k_LIMIT : @(limit).stringValue
                              };
    
    self = [super initWith:[APIDefine profile_followingLink] Params:params];
    
    return self;
}
-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token userID:(NSInteger)uid {
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(uid).stringValue
                              };
    
    self = [super initWith:[APIDefine profile_followingLink] Params:params];
    
    return self;
}

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token {
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token
                              };
    
    self = [super initWith:[APIDefine profile_followingLink] Params:params];

    return self;
}

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token limit:(NSInteger)limit sort:(NSString*)sort
{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @"",
                              k_LIMIT : @(limit).stringValue,
                              k_SORT : sort
                              };
    
    self = [super initWith:[APIDefine profile_followingLink] Params:params];
    

    return self;
}

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid limit:(NSInteger)limit sort:(NSString*)sort
{
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(uid).stringValue,
                              k_LIMIT : @(limit).stringValue,
                              k_SORT : sort
                              };
    
    self = [super initWith:[APIDefine profile_followingLink] Params:params];
    

    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_following_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_following_fetches alloc] init];
}

@end
