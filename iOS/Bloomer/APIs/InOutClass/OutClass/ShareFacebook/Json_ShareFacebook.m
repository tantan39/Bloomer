//
//  Json_ShareFacebook.m
//  Bloomer
//
//  Created by Steven on 12/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "Json_ShareFacebook.h"

@implementation Json_ShareFacebook

//- (void)extractData:(NSDictionary*) data
//{
//    self.flower = [[data objectForKey:k_NUM_FLOWER] integerValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        self.flower = [[json objectForKey:k_NUM_FLOWER] integerValue];
    }
    return self;
}

@end
