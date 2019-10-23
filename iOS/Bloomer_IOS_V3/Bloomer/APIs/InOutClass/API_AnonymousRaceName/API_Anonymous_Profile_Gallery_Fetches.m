//
//  API_Anonymous_Profile_Gallery_Fetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Anonymous_Profile_Gallery_Fetches.h"

@implementation API_Anonymous_Profile_Gallery_Fetches

- (instancetype)initWithUid:(NSInteger)uid{

    NSDictionary * params = @{k_USER_ID : @(uid).stringValue};
    self = [super initWith:[APIDefine anonymous_profile_galleryLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_profile_gallery_fetches alloc ] initWithJSON:json];
    }
    return (BaseJSON *) [[out_profile_gallery_fetches alloc] init];
}

@end
