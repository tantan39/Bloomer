//
//  transaction_check.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/11/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface transaction_check : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* access_token;
@property (strong, nonatomic) NSString* device_token;
@property (strong, nonatomic) NSString* transactionIdentifier;

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token transactionIdentifier:(NSString *)transactionIdentifier;

@end
