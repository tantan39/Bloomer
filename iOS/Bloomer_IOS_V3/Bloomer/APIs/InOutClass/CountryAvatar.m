//
//  CountryAvatar.m
//  Bloomer
//
//  Created by Tran Thai Tan on 7/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "CountryAvatar.h"

@implementation CountryAvatar

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.urlAvatar = json[k_AVATAR];
        self.child = json[k_CHILD];
        self.name = json[k_NAME];
    }
    
    return self;
}

@end
