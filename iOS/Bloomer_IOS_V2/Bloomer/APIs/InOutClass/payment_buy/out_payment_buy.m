//
//  out_payment_buy.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "out_payment_buy.h"

@implementation out_payment_buy

//-(void)extractData:(NSDictionary*) data
//{
//    NSLog(@"%@", data);
//    
//    _isDel = [[data objectForKey:@"isDel"] boolValue];
//    
//    if ([data objectForKey:k_FLOWER] != [NSNull null])
//    {
//        _num_flower = [[data objectForKey:k_FLOWER] longLongValue];
//    }
//    else
//    {
//        _num_flower = 0;
//    }
//    
//    if ([data objectForKey:k_TRANSACTION_IDENTIFIER] != [NSNull null])
//    {
//        _transactionIdentifier = [data objectForKey:k_TRANSACTION_IDENTIFIER];
//    }
//    else
//    {
//        _transactionIdentifier = @"";
//    }
//    
//    _state = [data objectForKey:k_STATE];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _isDel = [[json objectForKey:@"isDel"] boolValue];
        
        if ([json objectForKey:k_FLOWER] != [NSNull null])
        {
            _num_flower = [[json objectForKey:k_FLOWER] longLongValue];
        }
        else
        {
            _num_flower = 0;
        }
        
        if ([json objectForKey:k_TRANSACTION_IDENTIFIER] != [NSNull null])
        {
            _transactionIdentifier = [json objectForKey:k_TRANSACTION_IDENTIFIER];
        }
        else
        {
            _transactionIdentifier = @"";
        }
        
        _state = [json objectForKey:k_STATE];
    }
    return self;
}

@end
