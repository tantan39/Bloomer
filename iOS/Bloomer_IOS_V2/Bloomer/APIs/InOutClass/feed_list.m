//
//  feed_list.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/11/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "feed_list.h"

@implementation feed_list

- (id)initWithRacekey:(NSString *)racekey content_type:(NSString *)content_type content_id:(NSString *)content_id start:(NSString *)start end:(NSString *)end racenames:(NSString *)racenamse feed_id:(NSString *)feed_id isAlbum:(BOOL)is_album caption:(NSString *)caption flower:(long long)flower photoID:(NSString *)photo_id photoURL:(NSString *)photo_url postID:(NSString *)post_id tags:(NSMutableArray *)tags post:(NSMutableArray *)post timeStamp:(long long)timestamp avatar:(NSString *)avatar name:(NSString *)name uid:(NSInteger)uid isShare:(BOOL)is_share username:(NSString *)username totalPost:(NSInteger)totalPost mygiveflower:(long long)mygiveflower {
    self = [super init];
    
    if (self)
    {
        _racekey = racekey;
        _content_type = content_type;
        _content_id = content_id;
        _start = start;
        _end = end;
        _racenames = racenamse;
        _feed_id = feed_id;
        _is_album = is_album;
        _caption = caption;
        _flower = flower;
        _photo_id = photo_id;
        _photo_url = photo_url;
        _post_id = post_id;
        _tags = tags;
        _post = post;
        _timestamp = timestamp;
        _avatar = avatar;
        _name = name;
        _uid = uid;
        _is_share = is_share;
        _username = username;
        _total_post = totalPost;
        self.mygiveflower = mygiveflower;
    }
    
    return self;
}

@end
