//
//  out_notification_listUser.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_notification_listUser.h"
#import "follower.h"

@implementation out_notification_listUser

-(id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _listUser = [[NSMutableArray alloc] init];
        
        self.index = [[json objectForKey:@"index"] integerValue];
        
        NSArray* output = [json objectForKey:@"data"];
        NSInteger n = [output count];
        
        for(NSInteger i = 0; i < n; i++)
        {
            NSDictionary* temp = [output objectAtIndex:i];
            
            //        notification_user *addData = [[notification_user alloc] init];
            //
            //        [addData extractData:temp];
            //        [_listUser addObject:addData];
            
            follower *data = [[follower alloc] initWithUid:[[temp objectForKey:k_UID] integerValue]
                                                  isFollow:[[temp objectForKey:k_IS_FOLLOW] boolValue]
                                                    mocode:[temp objectForKey:k_MOCODE]
                                                    flower:[[temp objectForKey:@"gave_follower"] longLongValue]
                                                      name:/*_name*/[temp objectForKey:k_NAME]
                                                    isChat:[[temp objectForKey:k_IS_CHAT] boolValue]
                                                    avatar:[temp objectForKey:k_AVATAR]
                                                    spcode:[temp objectForKey:@"spcode"]
                                                  username:[temp objectForKey:k_USERNAME]
                                                 timestamp:[[temp objectForKey:k_TIME] longLongValue] / 1000
                                            matchingFlower:[[temp objectForKey:@"matching_flower"] boolValue]];
            
            [_listUser addObject:data];
            
        }
    }
    return self;
}

//-(void)extractData:(NSDictionary*) data
//{
//    _listUser = [[NSMutableArray alloc] init];
//
//    self.index = [[data objectForKey:@"index"] integerValue];
//
//    NSArray* output = [data objectForKey:@"data"];
//    NSInteger n = [output count];
//
//    for(NSInteger i = 0; i < n; i++)
//    {
//        NSDictionary* temp = [output objectAtIndex:i];
//
////        notification_user *addData = [[notification_user alloc] init];
////
////        [addData extractData:temp];
////        [_listUser addObject:addData];
//
//        follower *data = [[follower alloc] initWithUid:[[temp objectForKey:k_UID] integerValue]
//                                              isFollow:[[temp objectForKey:k_IS_FOLLOW] boolValue]
//                                                mocode:[temp objectForKey:k_MOCODE]
//                                                flower:[[temp objectForKey:@"gave_follower"] longLongValue]
//                                                  name:/*_name*/[temp objectForKey:k_NAME]
//                                                isChat:[[temp objectForKey:k_IS_CHAT] boolValue]
//                                                avatar:[temp objectForKey:k_AVATAR]
//                                                spcode:[temp objectForKey:@"spcode"]
//                                              username:[temp objectForKey:k_USERNAME]
//                                             timestamp:[[temp objectForKey:k_TIME] longLongValue] / 1000];
//
//        [_listUser addObject:data];
//
//    }
//}

@end
