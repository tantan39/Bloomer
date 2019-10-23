//
//  feed_winner.m
//  Bloomer
//
//  Created by VanLuu on 6/1/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "feed_winner.h"

@implementation feed_winner
-(id) initWithUserID:(NSInteger)uid moCode:(NSString *)moCode name:(NSString *)name avatar:(NSString *)avatar spCode:(NSString *)spCode username:(NSString *)username flower:(NSInteger)flower
{
    self= [super init];
    if(self)
    {
        _uid = uid;
        _moCode = moCode;
        _name = name;
        _avatar = avatar;
        _spCode = spCode;
        _username = username;
        _flower = flower;
    }
    return self;
}
@end
