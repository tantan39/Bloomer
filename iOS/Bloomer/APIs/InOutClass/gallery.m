//
//  gallery.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "gallery.h"

@implementation gallery

- (id)initWithPostID:(NSString *)post_id photoURL:(NSString *)photo_url photo_id:(NSString *)photo_id myGiveFlower:(long) flower{
    self = [super init];
    
    if (self)
    {
        _post_id = post_id;
        _photo_url = photo_url;
        _photo_id = photo_id;
        _mygiveflower = flower;
    }
    
    return self;
}

@end
