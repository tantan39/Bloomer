//
//  API_Profile_Gallery_Fetches.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_Gallery_Fetches.h"

@implementation API_Profile_Gallery_Fetches

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid{
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : @(uid).stringValue
                              };
    self = [super initWith:[APIDefine profile_galleryLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *) [[out_profile_gallery_fetches alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_profile_gallery_fetches alloc] init];
}

@end
