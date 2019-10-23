//
//  out_following_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/4/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_following_fetches.h"

@implementation out_following_fetches

@synthesize followingList;

//- (void)extractData:(NSDictionary *)data {
//    NSLog(@"Following data: %@", data);
//    NSArray *output = [data objectForKey:k_FOLLOWINGS];
//    followingList = [[NSMutableArray alloc] init];
//    self.isFinal = [[data objectForKey:k_IS_FINAL] boolValue];
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i< n ; i++) {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
////        NSData *nameData = [[temp objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
////        NSString* _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
//        
//        follower *new = [[follower alloc] initWithUid:[[temp objectForKey:k_UID] integerValue]
//                                             isFollow:[[temp objectForKey:k_IS_FOLLOW] boolValue]
//                                               mocode:[temp objectForKey:@"mocode"]
//                                           flower:[[temp objectForKey:@"gave_follower"] longLongValue]
//                                                 name:/*_name*/
//                          [temp objectForKey:k_NAME]
//                                               isChat:[[temp objectForKey:k_IS_CHAT] boolValue]
//                                               avatar:[temp objectForKey:k_AVATAR]
//                                               spcode:[temp objectForKey:@"spcode"]
//                                             username:[temp objectForKey:k_USERNAME]
//                                            timestamp:[[temp objectForKey:k_TIME] longLongValue] / 1000] ;
//        [followingList addObject:new];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSLog(@"Following data: %@", json);
        NSArray *output = [json objectForKey:k_FOLLOWINGS];
        followingList = [[NSMutableArray alloc] init];
        self.isFinal = [[json objectForKey:k_IS_FINAL] boolValue];
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            //        NSData *nameData = [[temp objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
            //        NSString* _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
            
            follower *new = [[follower alloc] initWithUid:[[temp objectForKey:k_UID] integerValue]
                                                 isFollow:[[temp objectForKey:k_IS_FOLLOW] boolValue]
                                                   mocode:[temp objectForKey:@"mocode"]
                                                   flower:[[temp objectForKey:@"gave_follower"] longLongValue]
                                                     name:[temp objectForKey:k_NAME]
                                                   isChat:[[temp objectForKey:k_IS_CHAT] boolValue]
                                                   avatar:[temp objectForKey:k_AVATAR]
                                                   spcode:[temp objectForKey:@"spcode"]
                                                 username:[temp objectForKey:k_USERNAME]
                                                timestamp:[[temp objectForKey:k_TIME] longLongValue] / 1000
                                           matchingFlower:[[temp objectForKey:kMatchingFlower] boolValue]];
            [followingList addObject:new];
        }
    }
    return self;
}

@end
