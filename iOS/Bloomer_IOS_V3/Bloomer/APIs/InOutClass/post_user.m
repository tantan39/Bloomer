//
//  post_user.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "post_user.h"

@implementation post_user

- (id)initWithPostID:(NSString *)post_id photoURL:(NSString *)photo_url isAvatar:(BOOL)isAvatar {
    self = [super init];
    
    if (self)
    {
        _post_id = post_id;
        _photo_url = photo_url;
        _isAvatar = isAvatar;
    }
    
    return self;
}

@end
