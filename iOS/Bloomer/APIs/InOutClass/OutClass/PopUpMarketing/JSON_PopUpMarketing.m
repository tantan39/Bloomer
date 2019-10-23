//
//  JSON_PopUpMarketing.m
//  Bloomer
//
//  Created by Steven on 4/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_PopUpMarketing.h"

@implementation JSON_PopUpMarketing

//- (void)extractData:(NSDictionary*)data
//{
//    NSArray *popUps = [data objectForKey:@"data"];
//    self.popUps = [[NSMutableArray alloc] init];
//    
//    for(NSInteger i = 0 ; i < popUps.count; i++)
//    {
//        NSDictionary *json = [popUps objectAtIndex:i];
//        NSDictionary *contentJSON = [json objectForKey:@"content"];
//        NSDictionary *bodyJSON = [contentJSON objectForKey:@"body"];
//        
//        PopUpMarketing *popUp = [[PopUpMarketing alloc] initWithID:[[json objectForKey:@"ID"] integerValue] startDate:[json objectForKey:@"start"] endDate:[json objectForKey:@"end"] type:[[json objectForKey:@"type"] integerValue] bodyLink:[bodyJSON objectForKey:@"link"] bodyText:[bodyJSON objectForKey:@"text"]];
//        
//        [self.popUps addObject:popUp];
//    }
//}

-(instancetype)initWithJSON:(NSDictionary *)data {
    self = [super init];
    if(self) {
        NSArray *popUps = [data objectForKey:@"data"];
        self.popUps = [[NSMutableArray alloc] init];
        
        for(NSInteger i = 0 ; i < popUps.count; i++)
        {
            NSDictionary *json = [popUps objectAtIndex:i];
            NSDictionary *contentJSON = [json objectForKey:@"content"];
            NSDictionary *bodyJSON = [contentJSON objectForKey:@"body"];
            
            PopUpMarketing *popUp = [[PopUpMarketing alloc] initWithID:[[json objectForKey:@"id"] integerValue] startDate:[json objectForKey:@"start"] endDate:[json objectForKey:@"end"] type:[[json objectForKey:@"type"] integerValue] bodyLink:[bodyJSON objectForKey:@"link"] bodyText:[bodyJSON objectForKey:@"text"]];
            
            [self.popUps addObject:popUp];
        }
    }
    return self;
}

@end
