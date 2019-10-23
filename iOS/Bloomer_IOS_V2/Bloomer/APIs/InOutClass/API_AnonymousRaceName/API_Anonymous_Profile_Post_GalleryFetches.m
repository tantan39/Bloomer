//
//  API_Anonymous_Profile_Post_GalleryFetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/5/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_Profile_Post_GalleryFetches.h"

@implementation API_Anonymous_Profile_Post_GalleryFetches

- (instancetype)initWithKey:(NSString *)key uid:(NSInteger)uid post_id:(NSString *)post_id limit:(NSInteger)limit{

    NSDictionary * params = @{k_KEY : key,
                              k_USER_ID : @(uid).stringValue,
                              k_POST_ID : post_id,
                              k_LIMIT : @(limit).stringValue
                              };
    self = [super initWith:[APIDefine anonymous_profile_post_galleryLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[JSON_GalleryFetches alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[JSON_GalleryFetches alloc] init];
}

@end
