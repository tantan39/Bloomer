//
//  post_detail.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "post_detail.h"

@implementation post_detail

@synthesize timestamp, content_post, num_flower, num_giver, give, uid_account, screen_name_account, post_id, photo_id, commentData,avatar_account,photo_id_account;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        give = [[givers alloc] initWithJSON:json];
        
        commentData = [[out_post_comment_fetch alloc]initWithJSON:json];
        
        timestamp = [[json objectForKey:k_TIMESTAMP] integerValue];
        
        content_post = [json objectForKey:k_CONTENT_POST];
        
        num_giver = [[json objectForKey:k_NUM_GIVER] integerValue];
        
        NSDictionary * account = [json objectForKey:k_ACCOUNT];
        
        uid_account = [[account objectForKey:k_UID] integerValue];
        
        screen_name_account = [account objectForKey:k_SCREEN_NAME];
        
        avatar_account = [account objectForKey:k_AVATAR];
        
        photo_id_account = [account objectForKey:k_PHOTO_ID];
        
        post_id = [json objectForKey:k_POST_ID];
        
        photo_id = [json objectForKey:k_PHOTO_ID];
        
        num_flower = [[json objectForKey:k_NUM_FLOWER] longLongValue];
        
        _photo = [json objectForKey:k_PHOTO];
    }
    return self;
}

@end
