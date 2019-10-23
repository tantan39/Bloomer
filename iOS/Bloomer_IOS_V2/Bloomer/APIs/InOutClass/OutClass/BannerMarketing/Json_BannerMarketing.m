//
//  Json_BannerMarketing.m
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "Json_BannerMarketing.h"

@implementation Json_BannerMarketing

-(instancetype)initWithJSON:(NSDictionary *)data {
    self = [super init];
    if(self) {
        NSArray *bannerList = [data objectForKey:@"data"];
        self.banners = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0 ; i < bannerList.count; i++)
        {
            NSDictionary *json = [bannerList objectAtIndex:i];
            NSDictionary *contentJSON = [json objectForKey:@"content"];
            NSDictionary *bodyJSON = [contentJSON objectForKey:@"body"];
            NSDictionary *footJSON = [contentJSON objectForKey:@"foot"];
            NSDictionary *headJSON = [contentJSON objectForKey:@"head"];
            
            BannerMarketing *banner = [[BannerMarketing alloc] initWithID:[[json objectForKey:@"ID"] integerValue] startDate:[json objectForKey:@"start"] endDate:[json objectForKey:@"end"] type:[[json objectForKey:@"type"] integerValue] bodyLink:[bodyJSON objectForKey:@"link"] bodyText:[bodyJSON objectForKey:@"text"] footLink:[footJSON objectForKey:@"link"] headLink:[headJSON objectForKey:@"link"]];
            
            [self.banners addObject:banner];
        }
    }
    return self;
}

@end
