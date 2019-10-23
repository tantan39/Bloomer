//
//  out_profile_post_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_profile_post_fetches.h"

@implementation out_profile_post_fetches

@synthesize photoList;

//- (void)extractData:(NSDictionary *)data {
//    NSArray *output = [data objectForKey:k_PHOTOS];
//    photoList = [[NSMutableArray alloc] init];
//    
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i < n ; i++) {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//        photo *new = [[photo alloc] initWithPostID:[temp objectForKey:k_POST_ID] photo_id:[temp objectForKey:k_PHOTO_ID] photo_url:[temp objectForKey:k_PHOTO_URL]];
//        
//        [photoList addObject:new];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_PHOTOS];
        photoList = [[NSMutableArray alloc] init];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i < n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            photo *new = [[photo alloc] initWithPostID:[temp objectForKey:k_POST_ID] photo_id:[temp objectForKey:k_PHOTO_ID] photo_url:[temp objectForKey:k_PHOTO_URL]photo_url_fullSize:[temp objectForKey:@"photo_uri_large"]];
            
            [photoList addObject:new];
        }
    }
    return self;
}

@end
