//
//  sponsors.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "sponsors.h"

@implementation sponsors

@synthesize uid, screen_name, avatar, photo_id, num_flower;

//-(void)extractData:(NSDictionary *)data
//{
//    uid = [[data objectForKey:k_UID] integerValue];
//    screen_name = [data objectForKey:k_SCREEN_NAME];
//    avatar = [data objectForKey:k_AVATAR];
//    photo_id = [data objectForKey:k_PHOTO_ID];
//    num_flower = [[data objectForKey:k_NUM_FLOWER] longLongValue];
//    _isActiveProfile = [[data objectForKey:k_IS_ACTIVE_PROFILE] boolValue];
//    _is_chat = [[data objectForKey:k_IS_CHAT] boolValue];
//    _is_block = [[data objectForKey:k_IS_BLOCK] boolValue];
//
//    if ([data objectForKey:k_BLOCKER] != [NSNull null])
//    {
//        _blocker = [[data objectForKey:k_BLOCKER] integerValue];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        uid = [[json objectForKey:k_UID] integerValue];
        screen_name = [json objectForKey:k_SCREEN_NAME];
        avatar = [json objectForKey:k_AVATAR];
        photo_id = [json objectForKey:k_PHOTO_ID];
        num_flower = [[json objectForKey:k_NUM_FLOWER] longLongValue];
        _isActiveProfile = [[json objectForKey:k_IS_ACTIVE_PROFILE] boolValue];
        _is_chat = [[json objectForKey:k_IS_CHAT] boolValue];
        _is_block = [[json objectForKey:k_IS_BLOCK] boolValue];
        
        if ([json objectForKey:k_BLOCKER] != [NSNull null])
        {
            _blocker = [[json objectForKey:k_BLOCKER] integerValue];
        }
    }
    return self;
}

@end
