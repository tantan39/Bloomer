//
//  IAPTransaction.h
//  Bloomer
//
//  Created by Tan Tan on 8/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPTransaction : NSObject

- (instancetype)initWithTransaction:(SKPaymentTransaction *) trans ReceiptData:(NSString *) receipt TransactionID:(NSString *) transID;


@property (strong,nonatomic) SKPaymentTransaction * skPaymentTransaction;
@property (strong,nonatomic) NSString * receiptData;
@property (strong,nonatomic) NSString * transactionID;
@end
