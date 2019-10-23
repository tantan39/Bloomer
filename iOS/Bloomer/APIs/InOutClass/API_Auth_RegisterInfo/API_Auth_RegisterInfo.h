//
//  API_Auth_RegisterInfo.h
//  Bloomer
//
//  Created by Tan Tan on 10/17/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "RegisterInfo.h"
#import "JSON_Auth_RegisterInfo.h"
@interface API_Auth_RegisterInfo : BloomerRestful

- (instancetype ) initWithRegisterInfo:(RegisterInfo *) info;
@end
