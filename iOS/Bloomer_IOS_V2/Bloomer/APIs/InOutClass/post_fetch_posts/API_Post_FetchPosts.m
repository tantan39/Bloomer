//
//  API_Post_FetchPosts.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Post_FetchPosts.h"

@implementation API_Post_FetchPosts

- (instancetype)initWithAccessToken:(NSString *)token min:(NSInteger)minValue max:(NSInteger)maxValue postID:(NSString *)postid{

    NSDictionary * params = @{k_ACCESS_TOKEN : token,
                              k_MIN : [NSString stringWithFormat:@"%ld",(long)minValue],
                              k_MAX : [NSString stringWithFormat:@"%ld",(long)maxValue],
                              k_POST_ID : postid
                              };
    self = [super initWith:[APIDefine post_fetch_postsLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    if (json) {
        return  (BaseJSON *)[[out_post_fetch_posts alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_post_fetch_posts alloc] init];
}
@end
