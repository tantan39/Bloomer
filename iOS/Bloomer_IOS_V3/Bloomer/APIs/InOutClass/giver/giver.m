//
//  giver.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "giver.h"

@implementation giver

@synthesize uid, screen_name;

-(id)initWithUid:(NSInteger)userID andScreenName:(NSString *) name
{
    self= [super init];
    if(self)
    {
        uid = userID;
        screen_name = name;
    }
    
    return self;
}


- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        uid = [[json objectForKey:k_UID] integerValue];
        screen_name = [json objectForKey:k_SCREEN_NAME];
    }
    return self;
}

@end
