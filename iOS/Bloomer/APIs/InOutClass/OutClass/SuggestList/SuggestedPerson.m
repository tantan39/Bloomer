//
//  SuggestedPerson.m
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "SuggestedPerson.h"

@implementation SuggestedPerson

- (id)initWithUID:(NSInteger)uid name:(NSString*)name avatar:(NSString*)avatar username:(NSString*)username
{
    self.uid = uid;
    self.name = name;
    self.avatar = avatar;
    self.username = username;
    
    return self;
}

@end
