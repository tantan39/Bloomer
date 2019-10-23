//
//  out_user_feed.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/31/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_user_feed.h"

@implementation out_user_feed
@synthesize feedList;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *feeds = [json objectForKey:k_FEEDS];
        feedList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0 ; i < feeds.count ; i++) {
            NSDictionary *temp = [feeds objectAtIndex:i];
            
            NSDictionary *feed = [temp objectForKey:k_FEED];
            
            NSDictionary *post; //= [[NSDictionary alloc] init];
            NSMutableArray *postss = [[NSMutableArray alloc] init];
            
            if (![[feed objectForKey:k_IS_ALBUM] boolValue]) {
                post = [feed objectForKey:k_POST];
            } else {
                NSArray *posts = [feed objectForKey:k_POST];
                
                for (int i = 0 ; i < posts.count; i++) {
                    NSDictionary *tem = [posts objectAtIndex:i];
                    feed_pic *new = [[feed_pic alloc] initWithPhotoID:[tem objectForKey:k_POST_ID] photo_url:[tem objectForKey:k_PHOTO_URL] mygiveflower:[[tem objectForKey:k_MYGIVEFLOWER] longLongValue]];
                    [postss addObject:new];
                }
            }
            
            NSDictionary *profile = [temp objectForKey:k_PROFILE];
            
            feed_list *new = [[feed_list alloc] initWithRacekey:[temp objectForKey:k_RACEKEY]
                                                   content_type:[temp objectForKey:k_CONTENT_TYPE]
                                                     content_id:[temp objectForKey:k_CONTENT_ID]
                                                          start:[temp objectForKey:k_START]
                                                            end:[temp objectForKey:k_END]
                                                      racenames:[temp objectForKey:k_RACENAMES]
                                                        feed_id:[feed objectForKey:k_FEED_ID]
                                                        isAlbum:[[feed objectForKey:k_IS_ALBUM] boolValue]
                                                        caption:[[post objectForKey:k_CAPTION]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]
                                                         flower:[[post objectForKey:k_FLOWER] longLongValue]
                                                        photoID:[post objectForKey:k_PHOTO_ID]
                                                       photoURL:[post objectForKey:k_PHOTO_URL]
                                                         postID:[post objectForKey:k_POST_ID]
                                                           tags:[post objectForKey:k_TAGS]
                                                           post:postss
                                                      timeStamp:[[feed objectForKey:k_TIMESTAMP] longLongValue]
                                                         avatar:[profile objectForKey:k_AVATAR]
                                                           name:/*_name*/[profile objectForKey:k_NAME]
                                                            uid:[[profile objectForKey:k_UID] integerValue]
                                                        isShare:[[profile objectForKey:k_IS_SHARE] boolValue]
                                                       username:[profile objectForKey:k_USERNAME]
                                                      totalPost:[[feed objectForKey:k_TOTAL_POST] integerValue]
                                                   mygiveflower:[[post objectForKey:k_MYGIVEFLOWER] longLongValue]];
            if (post == nil)
            {
                [new setFlower:[[feed objectForKey:k_TOTAL_FLOWER] longLongValue]];
            }
            [feedList addObject:new];
        }
    }
    return self;
}

@end


@implementation out_user_feed_content
@synthesize contentList;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *posts = [json objectForKey:k_POSTS];
        NSDictionary *profile = [json objectForKey:k_PROFILE];
        contentList = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < posts.count; i++) {
            NSDictionary *content = [posts objectAtIndex:i];
            out_content_post *detailPost = [[out_content_post alloc] init];
            detailPost.avatar = [profile objectForKey:k_AVATAR];
            detailPost.is_share = [[profile objectForKey:k_IS_SHARE] boolValue];
            
            detailPost.name = [profile objectForKey:k_NAME];
            
            
            detailPost.username = [profile objectForKey:k_USERNAME];
            detailPost.is_follow = [[profile objectForKey:k_IS_FOLLOW] boolValue];
            detailPost.uid = [[profile objectForKey:k_UID] integerValue];
            
            detailPost.post_id = [content objectForKey:k_POST_ID];
            //        detailPost.is_avatar = [[content objectForKey:k_IS_AVATAR] boolValue];
            detailPost.caption = [content objectForKey:k_CAPTION];
            detailPost.caption = [detailPost.caption stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            detailPost.timestamp = [[content objectForKey:k_TIMESTAMP] longLongValue];
            detailPost.flower = [[content objectForKey:k_FLOWER] longLongValue];
            detailPost.photo_url = [content objectForKey:k_PHOTO_URL];
            
            detailPost.tags =[[NSMutableArray alloc]init];
            NSMutableArray* tagList = [content objectForKey:k_TAGS];
            for (NSDictionary* tagObject in tagList) {
                [detailPost.tags addObject:[tagObject objectForKey:k_NAME]];
            }
            
            [contentList addObject:detailPost];
        }
    }
    return self;
}

@end
