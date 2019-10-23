//
//  races_search.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "races_search.h"

@implementation races_search

- (id)initWithName:(NSString *)name uid:(NSInteger)uid rank:(NSInteger)rank avatar:(NSString *)avatar username:(NSString *)username flower:(long long)flower {
    self = [super init];
    
    if (self)
    {
        _uid = uid;
        _rank = rank;
        _name = name;
        _username = username;
        _avatar = avatar;
        _flower = flower;
    }
    
    return self;
}

@end
