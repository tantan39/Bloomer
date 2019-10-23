//
//  BloomerManager.h
//  Bloomer
//
//  Created by Tran Thai Tan on 11/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Auth_FBRegisterParams.h"
#import "Country.h"
#import "IAPTransaction.h"
@interface BloomerManager : NSObject

+ (instancetype) shareInstance;

@property (strong,nonatomic) Auth_FBRegisterParams * auth_FBRegister;
@property (assign,nonatomic) NSInteger countryID;
@property (strong,nonatomic) NSString* country_short_name;
@property (strong, nonatomic) NSMutableArray<Country*> *listCountry;
@property (strong, nonatomic) NSMutableArray<IAPTransaction *> *listIAPTransaction;
@property AUTHENTYPE AuthenType;

@end
