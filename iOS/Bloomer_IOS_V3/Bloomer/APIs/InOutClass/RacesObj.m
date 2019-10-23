//
//  races.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RacesObj.h"

@implementation RacesObj

- (id)initWithName:(NSString *)name
               uid:(NSInteger)uid
          username:(NSString *)username
            flower:(long long)flower
              rank:(NSInteger)rank
            avatar:(NSString *)avatar
            moCode:(NSString *)moCode
            spCode:(NSString *)spCode
           aboutme:(NSString *)aboutme
           video_link:(NSString *)video_link
          gsbMedal:(NSString*)gsbMedal
{
    self = [super init];
    
    if (self)
    {
        _name = name;
        _uid = uid;
        _username = username;
        _flower = flower;
        _rank = rank;
        _avatar = avatar;
        _moCode = moCode;
        _spCode = spCode;
        _aboutme = aboutme;
        _video_link = video_link;
        self.gsbMedal = gsbMedal;
    }
    
    return self;
}

@end
