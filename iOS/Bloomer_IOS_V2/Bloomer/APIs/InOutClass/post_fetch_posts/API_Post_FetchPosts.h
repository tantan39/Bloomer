//
//  API_Post_FetchPosts.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_post_fetch_posts.h"

@interface API_Post_FetchPosts : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *) token min:(NSInteger) minValue max:(NSInteger)maxValue postID:(NSString *) postid;

@end
