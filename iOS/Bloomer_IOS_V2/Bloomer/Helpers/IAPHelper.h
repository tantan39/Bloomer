//
//  IAPHelper.h
//  Bloomer
//
//  Created by Le Chau Tu on 7/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "API_PaymentBuy.h"
#import "IAPTransaction.h"
#import "NSDate+Extension.h"
@interface IAPHelper : NSObject <SKPaymentTransactionObserver>

@property (strong, nonatomic) void (^paymentSuccess_callback)();

+(id)sharedInstance;

@end
