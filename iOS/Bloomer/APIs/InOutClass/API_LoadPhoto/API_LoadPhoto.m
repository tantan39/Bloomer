//
//  API_LoadPhoto.m
//  Bloomer
//
//  Created by Le Chau Tu on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_LoadPhoto.h"

@implementation API_LoadPhoto

-(id)initWithPhotoId:(NSString *)photo_id size:(NSString *)size {
    NSDictionary *params = @{k_PHOTO_ID: photo_id,
                             k_SIZE: size};
    self = [super initWith:[APIDefine loadPhoto] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_LoadPhoto *model;
    if(json) {
        model = [[JSON_LoadPhoto alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
