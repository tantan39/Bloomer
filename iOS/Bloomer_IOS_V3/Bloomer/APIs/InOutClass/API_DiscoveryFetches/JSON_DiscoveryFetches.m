//
//  JSON_Discovery_Fetches.m
//  Bloomer
//
//  Created by Ahri on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_DiscoveryFetches.h"

@implementation JSON_DiscoveryFetches

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSArray *discoveriesJSON = json[k_DISCOVERIES];
        self.discoveryList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < discoveriesJSON.count; i++) {
            NSDictionary *discoveryJSON = discoveriesJSON[i];
            NSDictionary *feedJSON = discoveryJSON[k_FEED];
            NSArray *postsJSON = feedJSON[k_POST];
            NSMutableArray *posts = [[NSMutableArray alloc] init];
            
            for (int j = 0; j < postsJSON.count; j++) {
                NSDictionary *postJSON = postsJSON[j];
                feed_pic *post = [[feed_pic alloc] initWithPhotoID:postJSON[k_POST_ID]
                                                         photo_url:postJSON[k_PHOTO_URL]
                                                      mygiveflower:-1];
                [posts addObject:post];
            }
            DiscoveryModel *discoveryObj = [[DiscoveryModel alloc] initWithUid:[discoveryJSON[k_UID] integerValue]
                                                      received_flower:[discoveryJSON[k_TOTAL_RECEIVED_FLOWER] longLongValue]
                                                                name:/*_name*/discoveryJSON[k_NAME]
                                                             username:discoveryJSON[k_USERNAME]
                                                               avatar:discoveryJSON[k_AVATAR]
                                                              isBlock:[discoveryJSON[k_IS_BLOCK] boolValue]
                                                                posts:posts
                                                              isAlbum:[feedJSON[k_IS_ALBUM] boolValue]
                                                            totalPost:[feedJSON[k_TOTAL_POST] integerValue]
                                                                        feedID:[feedJSON objectForKey:k_FEED_ID]];
            [self.discoveryList addObject:discoveryObj];
        }
    }
    return self;
}

@end
