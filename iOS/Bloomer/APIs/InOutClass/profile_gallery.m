//
//  profile_gallery.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/6/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "profile_gallery.h"

@implementation profile_gallery

- (id)initWithName:(NSString *)name key:(NSString *)key status:(NSInteger )status {
    self = [super init];
    
    if (self) {
        _name = name;
        _key = key;
        _status = status;
    }
    
    return self;
}

@end
