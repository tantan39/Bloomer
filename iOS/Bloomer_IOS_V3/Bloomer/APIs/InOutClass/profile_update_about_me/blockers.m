//
//  blockers.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "blockers.h"

@implementation blockers

- (id)initWithName:(NSString *)name uid:(NSInteger)uid avatar:(NSString *)avatar username:(NSString *)username {
    self = [super init];
    
    if (self)
    {
        _name = name;
        _uid = uid;
        _avatar = avatar;
        _username = username;
    }
    
    return self;
}

@end
