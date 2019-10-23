//
//  avatar.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "avatar.h"

@implementation avatar

- (id)initWithName:(NSString *)name key:(NSString *)key phptoURL:(NSString *)photo_url category:(NSInteger)categoryID{
    self = [super init];
    
    if (self) {
        _name = name;
        _key = key;
        _photo_url = photo_url;
        _categoryID = categoryID;
    }
    
    return self;
}

@end
