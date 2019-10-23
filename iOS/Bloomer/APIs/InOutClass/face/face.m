//
//  face.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "face.h"

@implementation face
@synthesize timestamp, uri_photo, uid, num_flower, avatar, post_id, photo_id, name;

-(id)initWithTimeStamp: (NSInteger) time uri_photo:(NSString*) uri name:(NSString*)userName uid:(NSInteger) user_id num_flower:(long long) num avatar:(NSString*) ava post_id:(NSString*)postid photo_id:(NSString*)photoid content_post:(NSString*)content_post;
{
    self = [super init];
    if(self)
    {
        timestamp = time;
        uri_photo = uri;
        uid = user_id;
        num_flower = num;
        avatar = ava;
        post_id = postid;
        photo_id = photoid;
        name = userName;
        _content_post = content_post;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:uid forKey:k_UID];
    [encoder encodeInteger:timestamp forKey:k_TIMESTAMP];
    [encoder encodeObject:name forKey:k_NAME];
    [encoder encodeObject:uri_photo forKey:k_URI_PHOTO];
    [encoder encodeInt64:num_flower forKey:k_NUM_FLOWER];
    [encoder encodeObject:avatar forKey:k_AVATAR];
    [encoder encodeObject:post_id forKey:k_POST_ID];
    [encoder encodeObject:photo_id forKey:k_PHOTO_ID];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        uid = [decoder decodeIntegerForKey:k_UID];
        timestamp = [decoder decodeIntegerForKey:k_TIMESTAMP];
        name = [decoder decodeObjectForKey:k_NAME];
        uri_photo = [decoder decodeObjectForKey:k_URI_PHOTO];
        num_flower = [decoder decodeInt64ForKey:k_NUM_FLOWER];
        avatar = [decoder decodeObjectForKey:k_AVATAR];
        post_id = [decoder decodeObjectForKey:k_POST_ID];
        photo_id = [decoder decodeObjectForKey:k_PHOTO_ID];
    }
    return self;
}

@end
