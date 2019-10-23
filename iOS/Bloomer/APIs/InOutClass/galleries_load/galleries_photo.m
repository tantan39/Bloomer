//
//  galleries_photo.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/30/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "galleries_photo.h"

@implementation galleries_photo

//-(void)extractData:(NSDictionary*) data
//{
//    _photoLink = [data objectForKey:k_PHOTO];
//    _photo_id = [data objectForKey:k_PHOTO_ID];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _photoLink = [json objectForKey:k_PHOTO];
        _photo_id = [json objectForKey:k_PHOTO_ID];
    }
    return self;
}
@end
