//
//  childs.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "childs.h"

@implementation childs

- (id)initWithName:(NSString *)name key:(NSString *)key {
    self = [super init];
    
    if (self)
    {
        _name = name;
        _key = key;
    }
    
    return self;
}

@end
