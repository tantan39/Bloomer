//
//  API_CheckPassword.h
//  Bloomer
//
//  Created by Tan Tan on 3/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_CheckPassword.h"
@interface API_Auth_CheckPassword : BloomerRestful

- (instancetype)initWithPhoneNumb:(NSString *) phoneNumb AppID:(NSInteger) appID CountryID:(NSInteger) countryID;

@end
