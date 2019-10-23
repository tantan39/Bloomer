//
//  PostContent.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Post.h"

@implementation Post

-(id)initWithContent:(PostContent *)content profile:(FeedProfile *)profile {
    self = [super init];
    if (self) {
        _content = content;
        _profile = profile;
    }
    return self;
}

@end
