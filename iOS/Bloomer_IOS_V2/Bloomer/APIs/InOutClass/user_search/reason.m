//
//  reason.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "reason.h"

@implementation reason

- (id)initWithType:(NSInteger)type ids:(NSInteger)ids active:(BOOL)active content:(NSString *)content {
    self = [super init];
    
    if (self) {
        _type = type;
        _ids = ids;
        _active = active;
        _content = content;
    }
    
    return self;
}

@end
