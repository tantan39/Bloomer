//
//  payment_buy.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/17/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface payment_buy : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *transactionIdentifier;
@property (strong, nonatomic) NSString *productIdentifier;
@property (strong, nonatomic) NSString *transactionDate;
@property (strong, nonatomic) NSString *transactionIdentifierStore;
@property (strong, nonatomic) NSString *receipt;
@property (strong, nonatomic) NSString *transactionFailBy;

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token transactionIdentifier:(NSString*)transactionIdentifier transactionIdentifierStore:(NSString*)transactionIdentifierStore state:(NSString*)state productIdentifier:(NSString*)productIdentifier transactionDate:(NSString*)transactionDate receipt_data:(NSString*)receipt_data transactionFailBy:(NSString*)transactionFailBy;

@end
