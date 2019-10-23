//
//  Feed.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Feed.h"

@implementation Feed

-(id)initWithContentType:(NSString *)content_type content_id:(NSString *)content_id profile:(FeedProfile*)profile is_album:(BOOL)is_album total_flower:(long long)total_flower total_post:(NSInteger)total_post feed_id:(NSString *)feed_id timestamp:(long long)timestamp posts:(NSMutableArray*)posts racename:(NSString *)racename racekey:(NSString *)racekey{
    self = [super init];
    if (self) {
        _content_type = content_type;
        _content_id = content_id;
        _profile = profile;
        _is_album = is_album;
        _total_flower = total_flower;
        _total_post = total_post;
        _feed_id = feed_id;
        _timestamp = timestamp;
        _posts = posts;
        _racekey = racekey;
        _racename = racename;
    }
    return self;
}

@end
