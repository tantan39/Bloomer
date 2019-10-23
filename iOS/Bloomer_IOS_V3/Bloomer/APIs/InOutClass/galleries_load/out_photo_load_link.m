//
//  out_photo_load_link.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_photo_load_link.h"

@implementation out_photo_load_link

//- (void)extractData:(NSDictionary *)data {
//
//    _photos = [[NSMutableArray alloc] init];
//
//    NSArray *output = [data objectForKey:k_PHOTOS];
//
//    NSInteger n = [output count];
//
//    for (NSInteger i = 0; i < n; i++) {
//
//        NSDictionary *temp = [output objectAtIndex:i];
//
//        galleries_photo *photo = [[galleries_photo alloc] init];
//
//        [photo extractData:temp];
//
//        [_photos addObject:photo];
//
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _photos = [[NSMutableArray alloc] init];
        
        NSArray *output = [json objectForKey:k_PHOTOS];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0; i < n; i++) {
            
            NSDictionary *temp = [output objectAtIndex:i];
            
            galleries_photo *photo = [[galleries_photo alloc] initWithJSON:temp];
            
            [_photos addObject:photo];
            
        }
    }
    return self;
}

@end
