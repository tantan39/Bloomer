//
//  API_Profile_Post_GalleryFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Post_GalleryFetches.h"

@implementation API_Profile_Post_GalleryFetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token key:(NSString *)key uid:(NSInteger)uid post_id:(NSString *)post_id limit:(NSInteger)limit{

    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_KEY : key != nil ? key : @"",
                              k_USER_ID : @(uid).stringValue,
                              k_POST_ID : post_id,
                              k_LIMIT : @(limit).stringValue
                              };
    self = [super initWith:[APIDefine profile_post_galleryLink] Params:params ];
    
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[JSON_GalleryFetches alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[JSON_GalleryFetches alloc] init];
}

@end
