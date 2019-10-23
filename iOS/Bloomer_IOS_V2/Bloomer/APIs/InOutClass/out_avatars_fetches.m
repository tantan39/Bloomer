//
//  out_avatars_fetches.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_avatars_fetches.h"

@implementation out_avatars_fetches

@synthesize avatarList;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *output = [json objectForKey:k_AVATARS];
        avatarList = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0 ; i < output.count ; i++) {
            NSDictionary *temp = [output objectAtIndex:i];
            
            avatar *new = [[avatar alloc] initWithName:[temp objectForKey:k_NAME] key:[temp objectForKey:k_KEY] phptoURL:[temp objectForKey:k_PHOTO_URL] category:[[temp objectForKey:k_CATEGORY] integerValue]];
            
            [avatarList addObject:new];
        }
    }
    return self;
}

@end
