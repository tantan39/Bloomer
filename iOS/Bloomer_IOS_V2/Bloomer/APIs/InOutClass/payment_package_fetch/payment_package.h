//
//  payment_package.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 8/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "BaseJSON.h"
//#import "jsonAbstractClassProtected.h"

@interface payment_package : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* productIdentifier;
@property (strong, nonatomic) NSString* productDescription;
@property (assign, nonatomic) float money;
@property (assign, nonatomic) NSInteger payment_id;
@property (assign, nonatomic) NSInteger flower;
@property (strong, nonatomic) NSString* currency;
@property (assign, nonatomic) Boolean isShot;

@end
