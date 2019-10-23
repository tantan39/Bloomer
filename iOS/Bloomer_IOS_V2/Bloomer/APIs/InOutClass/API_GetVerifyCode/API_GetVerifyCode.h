//
//  API_GetVerifyCode.h
//  Bloomer
//
//  Created by Tan Tan on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_GetVerifyCode.h"
@interface API_GetVerifyCode : BloomerRestful

- (instancetype)initWithPhoneNumb:(NSString *) phone CountryID:(NSInteger) countryID DeviceID:(NSString *) deviceID;


@end
