//
//  comments.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "comments.h"

@implementation comments

- (id)initWithName:(NSString *)name avatar:(NSString *)avatar username:(NSString *)username content:(NSString *)content uid:(NSInteger)uid timestamp:(long long)timestamp {
    self = [super init];
    
    if (self) {
        _name = name;
        _avatar = avatar;
        _username = username;
        _content = content;
        _uid = uid;
        _timestamp = timestamp;
    }
    
    return self;
}

@end
