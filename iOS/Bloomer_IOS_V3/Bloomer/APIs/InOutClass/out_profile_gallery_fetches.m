//
//  out_profile_gallery_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/6/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_profile_gallery_fetches.h"

@implementation out_profile_gallery_fetches

@synthesize galleryList;

//- (void)extractData:(NSDictionary *)data {
//    NSArray *output = [data objectForKey:k_GALLERIES];
//    galleryList = [[NSMutableArray alloc] init];
//    
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i< n ; i++) {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//        profile_gallery *new = [[profile_gallery alloc] initWithName:[temp objectForKey:k_NAME] key:[temp objectForKey:k_KEY] status:[[temp objectForKey:k_STATUS] integerValue]];
//        
//        [galleryList addObject:new];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_GALLERIES];
        galleryList = [[NSMutableArray alloc] init];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            profile_gallery *new = [[profile_gallery alloc] initWithName:[temp objectForKey:k_NAME] key:[temp objectForKey:k_KEY] status:[[temp objectForKey:k_STATUS] integerValue]];
            
            [galleryList addObject:new];
        }
    }
    return self;
}

@end
