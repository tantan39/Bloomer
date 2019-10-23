//
//  PostTag.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PostTag.h"

@implementation PostTag

-(id)initWithName:(NSString *)name key:(NSString *)key {
    self = [super init];
    if (self) {
        _name = name;
        _key = key;
    }
    return self;
}

@end
