//
//  out_following_search.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 2/22/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "out_following_search.h"

@implementation out_following_search

@synthesize followingList;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSLog(@"following search result: %@", json);
        NSArray *output = [json objectForKey:k_DISCOVERY_RESULT];
        followingList = [[NSMutableArray alloc] init];
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            //        NSData *nameData = [[temp objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
            //        NSString* _name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
            
            follower *new = [[follower alloc] initWithUid:[[temp objectForKey:k_UID] integerValue]
                                                 isFollow:![[temp objectForKey:k_IS_UNFOLLOW] boolValue]
                                                   mocode:[temp objectForKey:@"mocode"]
                                                   flower:[[temp objectForKey:@"gave_flower"] longLongValue]
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
