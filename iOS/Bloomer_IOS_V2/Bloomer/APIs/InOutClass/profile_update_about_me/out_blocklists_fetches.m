//
//  out_blocklists_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_blocklists_fetches.h"

@implementation out_blocklists_fetches

//- (void)extractData:(NSDictionary *)data {
//    
//    NSArray *output = [data objectForKey:k_BLOCKERS];
//    _blockList = [[NSMutableArray alloc] init];
//    
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i< n ; i++) {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//        blockers *new = [[blockers alloc] initWithName:[temp objectForKey:k_NAME] uid:[[temp objectForKey:k_UID] integerValue] avatar:[temp objectForKey:k_AVATAR] username:[temp objectForKey:k_USERNAME]];
//        
//        [_blockList addObject:new];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_BLOCKERS];
        _blockList = [[NSMutableArray alloc] init];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            blockers *new = [[blockers alloc] initWithName:[temp objectForKey:k_NAME] uid:[[temp objectForKey:k_UID] integerValue] avatar:[temp objectForKey:k_AVATAR] username:[temp objectForKey:k_USERNAME]];
            
            [_blockList addObject:new];
        }
    }
    return self;
}

@end
