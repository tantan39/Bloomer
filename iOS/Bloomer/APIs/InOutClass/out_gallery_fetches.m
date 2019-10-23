//
//  out_gallery_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_gallery_fetches.h"

@implementation out_gallery_fetches

@synthesize galleryList;

- (void)extractData:(NSDictionary *)data {
    NSArray *output = [data objectForKey:k_GALLERY];
    galleryList = [[NSMutableArray alloc] init];
    
    NSInteger n = [output count];
    
    for (NSInteger i = 0 ; i< n ; i++) {
        NSDictionary *temp = [output objectAtIndex:i];
        
        gallery *newBanner = [[gallery alloc] initWithPostID:[temp objectForKey:k_POST_ID] photoURL:[temp objectForKey:k_PHOTO_URL] photo_id:[temp objectForKey:k_PHOTO_ID]];
        
        [galleryList addObject:newBanner];
    }
}

@end
