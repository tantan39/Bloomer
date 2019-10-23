//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_PostUserFetches.h"

@implementation JSON_PostUserFetches

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *posts = [json objectForKey:k_POSTS];
        self.postUserList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <posts.count; i++) {
            NSDictionary *temp = posts[i];
            PostUserObj *post = [[PostUserObj alloc] initWithPostID:temp[k_POST_ID]
                                                       photoURL:temp[k_PHOTO_URL]
                                                       isAvatar:[temp[k_IS_AVATAR] boolValue]];
            [self.postUserList addObject:post];
        }
    }
    return self;
}

@end
