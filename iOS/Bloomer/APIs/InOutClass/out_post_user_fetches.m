//
//  out_post_user_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_post_user_fetches.h"

@implementation out_post_user_fetches

@synthesize postUserList;

- (void)extractData:(NSDictionary *)data {
    NSArray *output = [data objectForKey:k_POSTS];
    postUserList = [[NSMutableArray alloc] init];
    
    NSInteger n = [output count];
    
    for (NSInteger i = 0 ; i < n ; i++) {
        NSDictionary *temp = [output objectAtIndex:i];
        
        post_user *new = [[post_user alloc] initWithPostID:[temp objectForKey:k_POST_ID] photoURL:[temp objectForKey:k_PHOTO_URL] isAvatar:[[temp objectForKey:k_IS_AVATAR] boolValue]];
        
        [postUserList addObject:new];
    }
}

@end
