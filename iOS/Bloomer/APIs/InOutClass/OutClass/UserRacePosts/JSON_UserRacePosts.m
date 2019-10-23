//
//  JSON_UserRacePosts.m
//  Bloomer
//
//  Created by Steven on 4/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_UserRacePosts.h"

@implementation JSON_UserRacePosts

//- (void)extractData:(NSDictionary*) data
//{
//    NSArray *jsonPosts = [data objectForKey:k_GALLERY];
//    NSDictionary *jsonProfile = [data objectForKey:k_PROFILE];
//
//    NSInteger uid = [[jsonProfile objectForKey:k_UID] integerValue];
//    BOOL isShare = [[jsonProfile objectForKey:k_IS_SHARE] boolValue];
//    BOOL isFollow = [[jsonProfile objectForKey:k_IS_FOLLOW] boolValue];
//    NSString *name = [jsonProfile objectForKey:k_NAME];
//    NSString *avatar = [jsonProfile objectForKey:k_AVATAR];
//    NSString *username = [jsonProfile objectForKey:k_USERNAME];
//
//    self.posts = [[NSMutableArray alloc] init];
//
//    for(NSInteger i = 0 ; i < jsonPosts.count; i++)
//    {
//        NSDictionary *json = [jsonPosts objectAtIndex:i];
//
//        out_content_post *post = [[out_content_post alloc] init];
//
//        post.uid = uid;
//        post.is_share = isShare;
//        post.is_follow = isFollow;
//        post.name = name;
//        post.avatar = avatar;
//        post.username = username;
//
//        post.post_id = [json objectForKey:k_POST_ID];
//        post.is_avatar = [[json objectForKey:k_IS_AVATAR] boolValue];
//        post.caption = [json objectForKey:k_CAPTION];
//        post.caption = [post.caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        post.timestamp = [[json objectForKey:k_TIMESTAMP] longLongValue];
//        post.flower = [[json objectForKey:k_FLOWER] longLongValue];
//        post.photo_url = [json objectForKey:k_PHOTO_URL];
//        post.mygiveflower = [[json objectForKey:k_MYGIVEFLOWER] longLongValue];
//
//        [self.posts addObject:post];
//
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *jsonPosts = [json objectForKey:k_GALLERY];
        NSDictionary *jsonProfile = [json objectForKey:k_PROFILE];
        
        NSInteger uid = [[jsonProfile objectForKey:k_UID] integerValue];
        BOOL isShare = [[jsonProfile objectForKey:k_IS_SHARE] boolValue];
        BOOL isFollow = [[jsonProfile objectForKey:k_IS_FOLLOW] boolValue];
        NSString *name = [jsonProfile objectForKey:k_NAME];
        NSString *avatar = [jsonProfile objectForKey:k_AVATAR];
        NSString *username = [jsonProfile objectForKey:k_USERNAME];
        
        self.posts = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0 ; i < jsonPosts.count; i++)
        {
            NSDictionary *json = [jsonPosts objectAtIndex:i];
            
            out_content_post *post = [[out_content_post alloc] init];
            
            post.uid = uid;
            post.is_share = isShare;
            post.is_follow = isFollow;
            post.name = name;
            post.avatar = avatar;
            post.username = username;
            
            post.post_id = [json objectForKey:k_POST_ID];
            post.is_avatar = [[json objectForKey:k_IS_AVATAR] boolValue];
            post.caption = [json objectForKey:k_CAPTION];
            post.caption = [post.caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            post.timestamp = [[json objectForKey:k_TIMESTAMP] longLongValue];
            post.flower = [[json objectForKey:k_FLOWER] longLongValue];
            post.photo_url = [json objectForKey:k_PHOTO_URL];
            post.mygiveflower = [[json objectForKey:k_MYGIVEFLOWER] longLongValue];
            
            [self.posts addObject:post];
            
        }
    }
    return self;
}

@end
