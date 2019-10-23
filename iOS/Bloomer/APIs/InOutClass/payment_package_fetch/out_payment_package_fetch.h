//
//  out_payment_package_fetch.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "payment_package.h"

@interface out_payment_package_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *payments;
@property (assign, nonatomic) Boolean isActiveEvent;
@property (strong, nonatomic) NSString* titleEvent;
@property (strong, nonatomic) NSString* contentNotiEvent;
@property (strong, nonatomic) NSString* imageUrl;
@property (assign, nonatomic) NSInteger numberBonus;

@end
