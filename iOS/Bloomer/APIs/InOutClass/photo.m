//
//  photo.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "photo.h"

@implementation photo

- (id)initWithPostID:(NSString *)post_id photo_id:(NSString *)photo_id photo_url:(NSString *)photo_url photo_url_fullSize:(NSString *)photo_url_fullSize{
    self = [super init];
    
    if (self) {
        _post_id = post_id;
        _photo_id = photo_id;
        _photo_url = photo_url;
        _photo_url_fullSize = photo_url_fullSize;
    }
    
    return self;
}

@end
