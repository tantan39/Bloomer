//
//  JSON_GetFeed.m
//  Bloomer
//
//  Created by Tan Tan on 8/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_GetFeed.h"

@implementation JSON_GetFeed

- (instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        self.posts = [[NSMutableArray alloc] init];
        
        NSMutableArray *posts = [json objectForKey:k_POSTS];
        NSDictionary * jsonProfile = [json objectForKey:k_PROFILE];
        [posts enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                out_content_post *post = [[out_content_post alloc] initWithFeedJSON:obj];
                
                post.uid = [[jsonProfile objectForKey:k_UID] integerValue];
                post.is_share = [[jsonProfile objectForKey:k_IS_SHARE] boolValue];
                post.name = [jsonProfile objectForKey:k_NAME];
                post.avatar = [jsonProfile objectForKey:k_AVATAR];
                post.username = [jsonProfile objectForKey:k_USERNAME];
                post.is_follow = [[jsonProfile objectForKey:k_IS_FOLLOW] boolValue];
                
                [self.posts addObject:post];
            }
        }];
        
    }
    return self;
}

@end
