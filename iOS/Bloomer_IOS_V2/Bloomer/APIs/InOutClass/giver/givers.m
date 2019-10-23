//
//  givers.m
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import "givers.h"

@implementation givers

@synthesize giversData;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        giversData = [[NSMutableArray alloc] init];
        
        NSArray *output = [json objectForKey:k_GIVERS];
        
        NSInteger n = [output count];
        
        for(NSInteger i = 0 ; i< n ; i++)
        {
            NSDictionary *temp = [output objectAtIndex:i];
            
            giver *giverTemp = [[giver alloc] initWithJSON:temp];
            
            [giversData addObject:giverTemp];
        }
    }
    return self;
}
@end
