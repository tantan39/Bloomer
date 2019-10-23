//
//  out_banner_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "JSON_BannerFetch.h"

@implementation JSON_BannerFetch

@synthesize bannerList;

//- (void)extractData:(NSDictionary *)data {
//    NSArray *output = [data objectForKey:k_BANNER];
//    bannerList = [[NSMutableArray alloc] init];
//    
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i< n ; i++) {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//         banner *newBanner = [[banner alloc] initWithUid:[temp[k_UID] integerValue]
//                                                  rank:[temp[k_RANK] integerValue]
//                                               photoID:temp[k_PHOTO_ID]
//                                              photoURL:temp[k_PHOTO_URL]
//                                            postID:temp[k_POST_ID]
//                                                      x1:[temp[k_X1] floatValue]
//                                                      y1:[temp[k_Y1] floatValue]
//                                                      x2:[temp[k_X2] floatValue]
//                                                      y2:[temp[k_Y2] floatValue]];
//        
//        [bannerList addObject:newBanner];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *output = json[k_BANNER];
        bannerList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < output.count; i++) {
            NSDictionary *temp = output[i];
            BannerObj *newBanner = [[BannerObj alloc] initWithUid:[temp[k_UID] integerValue]
                                                             rank:[temp[k_RANK] integerValue]
                                                          photoID:temp[k_PHOTO_ID]
                                                         photoURL:temp[k_PHOTO_URL]
                                                           postID:temp[k_POST_ID]
                                                               x1:[temp[k_X1] floatValue]
                                                               y1:[temp[k_Y1] floatValue]
                                                               x2:[temp[k_X2] floatValue]
                                                               y2:[temp[k_Y2] floatValue]];
            
            [bannerList addObject:newBanner];
        }
        
    }
    return self;
}

@end
