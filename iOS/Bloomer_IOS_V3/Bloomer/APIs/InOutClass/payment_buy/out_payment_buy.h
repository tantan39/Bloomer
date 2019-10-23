//
//  out_payment_buy.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_payment_buy : NSObject<BaseJSON>

@property (assign, nonatomic) long long num_flower;
@property (strong, nonatomic) NSString* state;
@property (strong, nonatomic) NSString* transactionIdentifier;
@property (assign, nonatomic) BOOL isDel;

@end
