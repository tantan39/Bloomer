//
//  TopWinner.m
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "TopWinner.h"

@implementation TopWinner

- (id)initWithAvatar:(NSString*)avatar message:(NSString*)message popUpID:(NSString*)popUpID position:(NSInteger)position raceKey:(NSString*)raceKey raceName:(NSString*)raceName type:(NSString*)type url:(NSString*)url
{
    self = [super init];
    if (self)
    {
        self.avatar = avatar;
        self.message = message;
        self.popUpID = popUpID;
        self.position = position;
        self.raceKey = raceKey;
        self.raceName = raceName;
        self.type = type;
        self.url = url;
    }
    
    return self;
}

@end
