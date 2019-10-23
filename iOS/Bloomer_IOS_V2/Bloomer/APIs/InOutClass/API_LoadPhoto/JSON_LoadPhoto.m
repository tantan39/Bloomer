//
//  JSON_LoadPhoto.m
//  Bloomer
//
//  Created by Le Chau Tu on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_LoadPhoto.h"

@implementation JSON_LoadPhoto

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if(self) {
        _photo_url = [json objectForKey:k_PHOTO_URL];
    }
    return self;
}

@end
