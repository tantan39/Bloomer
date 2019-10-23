//
//  FeedProfile.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FeedProfile.h"

@implementation FeedProfile

-(id)initWithUid:(NSInteger)uid is_share:(BOOL)is_share is_follow:(BOOL)is_follow name:(NSString *)name avatar:(NSString *)avatar username:(NSString *)username {
    self = [super init];
    if (self) {
        _uid = uid;
        _is_share = is_share;
        _is_follow = is_follow;
        _name = name;
        _avatar = avatar;
        _username = username;
    }
    return self;
}

@end
