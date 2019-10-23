//
//  JSON_FeedList.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_FeedList.h"

@implementation JSON_FeedList

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _feeds = [[NSMutableArray alloc] init];
        for (NSDictionary* temp in [json objectForKey:k_FEEDS]) {
            NSMutableArray *posts = [[NSMutableArray alloc] init];
            NSDictionary* feed_dict = [temp objectForKey:k_FEED];
            BOOL isAlbum = [[feed_dict objectForKey:k_IS_ALBUM] boolValue];
            if (isAlbum) {
                for (NSDictionary* post_dict in [feed_dict objectForKey:k_POST]) {
                    PostContent *post = [[PostContent alloc] initWithPostId:[post_dict objectForKey:k_POST_ID]
                                                 mygiveflower:[[post_dict objectForKey:k_MYGIVEFLOWER] longLongValue]
                                                    photo_url:[post_dict objectForKey:k_PHOTO_URL]];
                    [posts addObject:post];
                }
            } else {
                NSDictionary *post_dict = [feed_dict objectForKey:k_POST];
                NSMutableArray *tags = [[NSMutableArray alloc] init];
                for (NSDictionary* tag_dict in [post_dict objectForKey:k_TAGS]) {
                    PostTag *postTag = [[PostTag alloc] initWithName:[tag_dict objectForKey:k_NAME] key:[tag_dict objectForKey:k_KEY]];
                    [tags addObject:postTag];
                }
                PostContent *post = [[PostContent alloc] initWithPostId:[post_dict objectForKey:k_POST_ID]
                                                 photo_id:[post_dict objectForKey:k_PHOTO_ID]
                                             mygiveflower:[[post_dict objectForKey:k_MYGIVEFLOWER] longLongValue]
                                                  caption:[post_dict objectForKey:k_CAPTION]
                                                photo_url:[post_dict objectForKey:k_PHOTO_URL]
                                                timestamp:[[post_dict objectForKey:k_TIMESTAMP] longLongValue]
                                                   flower:[[post_dict objectForKey:k_FLOWER] longLongValue]
                                                     tags:tags];
                [posts addObject:post];
            }
            NSDictionary* profile_dict = [temp objectForKey:k_PROFILE];
            
            FeedProfile *profile = [[FeedProfile alloc] initWithUid:[[profile_dict objectForKey:k_UID] integerValue]
                                                           is_share:[profile_dict objectForKey:k_IS_SHARE]
                                                          is_follow:[profile_dict objectForKey:k_IS_FOLLOW]
                                                               name:[profile_dict objectForKey:k_NAME]
                                                             avatar:[profile_dict objectForKey:k_AVATAR]
                                                           username:[profile_dict objectForKey:k_USERNAME]];
            
            Feed *feed = [[Feed alloc] initWithContentType:[temp objectForKey:k_CONTENT_TYPE]
                                                content_id:[temp objectForKey:k_CONTENT_ID]
                                                   profile:profile
                                                  is_album:isAlbum
                                              total_flower:[[feed_dict objectForKey:k_TOTAL_FLOWER] longLongValue]
                                                total_post:[[feed_dict objectForKey:k_TOTAL_POST] integerValue]
                                                   feed_id:[feed_dict objectForKey:k_FEED_ID]
                                                 timestamp:[[feed_dict objectForKey:k_TIMESTAMP] longLongValue]
                                                     posts:posts
                                                  racename:[temp objectForKey:k_RACENAMES]
                                                   racekey:[temp objectForKey:k_RACEKEY]];
            [_feeds addObject:feed];
        }
    }
    return self;
}


@end
