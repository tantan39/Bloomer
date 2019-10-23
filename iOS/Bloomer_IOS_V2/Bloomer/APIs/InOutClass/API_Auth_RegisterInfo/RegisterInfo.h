//
//  RegisterInfo.h
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface RegisterInfo : NSObject<BaseJSON>

@property (strong,nonatomic) NSString * email;
@property (strong,nonatomic) NSString * secretClient;
@property (strong,nonatomic) NSString * deviceToken;
@property (strong,nonatomic) NSString * screenName;
@property (strong,nonatomic) NSString * credential;
@property (assign,nonatomic) NSInteger countryID;
@property (assign,nonatomic) NSInteger appID;
@property (assign,nonatomic) NSInteger gender;

- (instancetype)initWithName:(NSString *) screenName SecretClient:(NSString *) secretClient Credential:(NSString *) credential DeviceID:(NSString *) deviceID Gender:(NSInteger) gender CountryID:(NSInteger) countryID AppID:(NSInteger) appID Email:(NSString *) email;

@end
