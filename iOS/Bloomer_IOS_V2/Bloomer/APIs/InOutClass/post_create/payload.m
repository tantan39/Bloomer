//
//  payload.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "payload.h"

@implementation payload

- (id)initWithPhotoID:(NSString *)photo_id caption:(NSString *)caption tags:(NSMutableArray *)tags {
    self = [super init];
    
    if (self)
    {
        _photo_id = photo_id;
        _caption = caption;
        _tags = tags;
    }
    
    return self;
}

@end
