//
//  out_payment_package_fetch.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_payment_package_fetch.h"

@implementation out_payment_package_fetch

//-(void)extractData:(NSDictionary*) data
//{
//    _payments = [[NSMutableArray alloc] init];
//
//    _titleEvent = [data objectForKey:K_PAYMENT_TITLE_EVENT];
//
//    _isActiveEvent = [[data objectForKey:K_PAYMENT_IS_EVENT] boolValue];
//
//    _contentNotiEvent = [data objectForKey:K_PAYMENT_NOTI_EVENT];
//
//    _numberBonus = [[data objectForKey:K_PAYMENT_PERCENT_BONUS] integerValue];
//
//    NSArray *array = [data objectForKey:k_PAYMENTS];
//    for (NSInteger i = 0; i < array.count; i++)
//    {
//        NSDictionary *dictionary = [array objectAtIndex:i];
//        payment_package *temp = [[payment_package alloc] init];
//
//        [temp extractData:dictionary];
//        [_payments addObject:temp];
//    }
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _payments = [[NSMutableArray alloc] init];
        
        _titleEvent = [json objectForKey:K_PAYMENT_TITLE_EVENT];
        
        _isActiveEvent = [[json objectForKey:K_PAYMENT_IS_EVENT] boolValue];
        
        _contentNotiEvent = [json objectForKey:K_PAYMENT_NOTI_EVENT];
        
        _imageUrl = [json objectForKey:@"payment_banner"];
        
        _numberBonus = [[json objectForKey:K_PAYMENT_PERCENT_BONUS] integerValue];
        
        NSArray *array = [json objectForKey:k_PAYMENTS];
        for (NSInteger i = 0; i < array.count; i++)
        {
            NSDictionary *dictionary = [array objectAtIndex:i];
            payment_package *temp = [[payment_package alloc] initWithJSON:dictionary];
            [_payments addObject:temp];
        }
    }
    return self;
}

@end
