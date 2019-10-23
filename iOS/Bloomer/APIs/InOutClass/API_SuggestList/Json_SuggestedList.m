//
//  Json_SuggestedList.m
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "Json_SuggestedList.h"

@implementation Json_SuggestedList

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *suggestedList = [json objectForKey:@"suggest_list"];
        
        self.suggestedPeople = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0 ; i < suggestedList.count; i++)
        {
            NSDictionary *temp = [suggestedList objectAtIndex:i];
            SuggestedPerson *person = [[SuggestedPerson alloc] initWithUID:[[temp objectForKey:k_UID] integerValue] name:[temp objectForKey:k_NAME] avatar:[temp objectForKey:k_AVATAR] username:[temp objectForKey:k_USERNAME]];
            
            [self.suggestedPeople addObject:person];
            
        }
    }
    return self;
}

@end
