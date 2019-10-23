//
//  feed_pic.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/14/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "feed_pic.h"

@implementation feed_pic

- (id)initWithPhotoID:(NSString *)photo_id photo_url:(NSString *)photo_url mygiveflower:(long long)mygiveflower {
    self = [super init];
    
    if (self)
    {
        _photo_id = photo_id;
        _photo_url = photo_url;
        self.mygiveflower = mygiveflower;
    }

    return self;
}

@end
