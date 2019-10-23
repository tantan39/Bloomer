//
//  API_Avatar_RaceAttached.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Avatar_RaceAttached.h"

@implementation API_Avatar_RaceAttached

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token image:(UIImage *)image key:(NSString *)key{
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_KEY : key};
    
    self = [super initWith:[APIDefine avatar_race_attchedLink] Params:params];
    self.dataImage = imageData;
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_avatar_attached alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_avatar_attached alloc] init];
}

@end
