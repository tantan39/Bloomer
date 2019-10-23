//
//  out_notification_pull.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/17/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_notification_pull.h"

@implementation out_notification_pull

//-(void)extractData:(NSDictionary*) data
//{
//    _rooms = [[NSMutableArray alloc] init];
//    
//    NSArray *rooms = [data objectForKey:k_ROOMS];
//    
//    for (NSInteger i = 0; i < rooms.count; i++)
//    {
//        [_rooms addObject:[rooms objectAtIndex:i]];
//    }
//    
//    NSDictionary *alert = [data objectForKey:k_ALERT];
//    _notification = [[alert objectForKey:k_NOTIFICATION] integerValue];
//    _message = [[alert objectForKey:k_MESSAGE] integerValue];
//    _total = [[alert objectForKey:k_TOTAL] integerValue];
//    
//    _redirect_url = [data objectForKey:k_REDIRECT_URI];
//    _isFreshRace = [[data objectForKey:k_IS_FRESH_RACE] integerValue];
//    _popup = [data objectForKey:k_POP_UP];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _rooms = [[NSMutableArray alloc] init];
        
        NSArray *rooms = [json objectForKey:k_ROOMS];
        
        for (NSInteger i = 0; i < rooms.count; i++)
        {
            [_rooms addObject:[rooms objectAtIndex:i]];
        }
        
        NSDictionary *alert = [json objectForKey:k_ALERT];
        _notification = [[alert objectForKey:k_NOTIFICATION] integerValue];
        _message = [[alert objectForKey:k_MESSAGE] integerValue];
        _total = [[alert objectForKey:k_TOTAL] integerValue];
        
        _redirect_url = [json objectForKey:k_REDIRECT_URI];
        _isFreshRace = [[json objectForKey:k_IS_FRESH_RACE] integerValue];
        _popup = [json objectForKey:k_POP_UP];
    }
    return self;
}

@end
