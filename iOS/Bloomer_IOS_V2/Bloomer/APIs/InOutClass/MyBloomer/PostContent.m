//
//  Post.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PostContent.h"

@implementation PostContent

-(id)initWithPostId:(NSString *)post_id photo_id:(NSString *)photo_id mygiveflower:(long long)mygiveflower caption:(NSString *)caption photo_url:(NSString *)photo_url timestamp:(long long)timestamp flower:(long long)flower tags:(NSMutableArray *)tags {
    self = [super init];
    if (self) {
        _post_id = post_id;
        _photo_id = photo_id;
        _mygiveflower = mygiveflower;
        _caption = caption;
        _photo_url = photo_url;
        _timestamp = timestamp;
        _flower = flower;
        _tags = tags;
    }
    return self;
}

-(id)initWithPostId:(NSString *)post_id mygiveflower:(long long)mygiveflower photo_url:(NSString *)photo_url {
    self = [super init];
    if (self) {
        _post_id = post_id;
        _mygiveflower = mygiveflower;
        _photo_url = photo_url;
    }
    return self;
}

@end
