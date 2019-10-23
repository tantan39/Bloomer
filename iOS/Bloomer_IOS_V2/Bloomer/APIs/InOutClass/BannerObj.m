//
//  banner.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BannerObj.h"

@implementation BannerObj

- (id)initWithUid:(NSInteger)uid
             rank:(NSInteger)rank
          photoID:(NSString *)photo_id
         photoURL:(NSString *)photo_url
           postID:(NSString *)post_id
               x1:(CGFloat)x1
               y1:(CGFloat)y1
               x2:(CGFloat)x2
               y2:(CGFloat)y2{
    self = [super init];
    
    if (self)
    {
        _uid = uid;
        _rank = rank;
        _photo_id = photo_id;
        _photo_url = photo_url;
        _post_id = post_id;
        
        self.x1 = x1;
        self.y1 = y1;
        self.x2 = x2;
        self.y2 = y2;
    }
    
    return self;
}

@end
