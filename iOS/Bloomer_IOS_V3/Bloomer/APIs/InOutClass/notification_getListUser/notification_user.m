//
//  notification_user.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "notification_user.h"

@implementation notification_user

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _avatar = [json objectForKey:@"avatar"];
        _userID = [[json objectForKey:@"uid"] integerValue];
        _userName = [json objectForKey:@"username"] ;
        _name = [json objectForKey:@"name"];
        _gaveNumber = [[json objectForKey:@"gave_follower"] integerValue];
    }
    return self;
}
@end
