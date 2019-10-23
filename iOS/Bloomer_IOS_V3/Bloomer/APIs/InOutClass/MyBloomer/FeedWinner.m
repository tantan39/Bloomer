//
//  FeedWinner.m
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FeedWinner.h"

@implementation FeedWinner

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
