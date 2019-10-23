//
//  AlbumInfo.m
//  Bloomer
//
//  Created by Steven on 6/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AlbumInfo.h"

@implementation AlbumInfo

- (id)initWithName:(NSString*)name totalPhoto:(NSInteger)totalPhoto thumbnail:(UIImage*)thumbnail
{
    self = [super init];
    
    if (self)
    {
        self.name = name;
        self.totalPhoto = totalPhoto;
        self.thumbnail = thumbnail;
    }
    
    return self;
}

@end
