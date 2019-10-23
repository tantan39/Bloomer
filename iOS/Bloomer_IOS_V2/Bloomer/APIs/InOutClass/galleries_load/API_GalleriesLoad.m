//
//  API_GalleriesLoad.m
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_GalleriesLoad.h"

@implementation API_GalleriesLoad

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token userID:(NSString *)Uid{
//    access_token=...&device_id=...&user_id=..
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_USER_ID : Uid
                              };
    self = [super initWith:[APIDefine galleriesLoadLink] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return (BaseJSON *)[[out_photo_load_link alloc] initWithJSON:json];
    }
    return (BaseJSON *)[[out_photo_load_link alloc] init];
}

@end
