//
//  out_avatar_attached.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "out_avatar_attached.h"

@implementation out_avatar_attached

//-(void)extractData:(NSDictionary*) data
//{
//    NSDictionary *photo = [data objectForKey:k_PHOTO];
//    _photo_id = [photo objectForKey:k_PHOTO_ID];
//    _photo_url = [photo objectForKey:k_PHOTO_URL];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSDictionary *photo = [json objectForKey:k_PHOTO];
        _photo_id = [photo objectForKey:k_PHOTO_ID];
        _photo_url = [photo objectForKey:k_PHOTO_URL];
    }
    return self;
}

@end
