//
//  out_gallery_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "JSON_GalleryFetches.h"

@implementation JSON_GalleryFetches

@synthesize galleryList;

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *output = json[k_GALLERY];
        galleryList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < output.count; i++) {
            NSDictionary *temp = output[i];
            
            gallery *newBanner = [[gallery alloc] initWithPostID:temp[k_POST_ID]
                                                        photoURL:temp[k_PHOTO_URL]
                                                        photo_id:temp[k_PHOTO_ID]
                                  myGiveFlower:[[temp objectForKey:k_MYGIVEFLOWER] longLongValue]];
                                  
            [galleryList addObject:newBanner];
        }
    }
    return self;
}

@end
