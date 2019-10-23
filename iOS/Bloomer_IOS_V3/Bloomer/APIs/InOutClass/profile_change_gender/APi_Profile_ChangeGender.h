//
//  APi_Profile_ChangeGender.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "profile_change_gender.h"
#import "out_auth_register_verifycode.h"
@interface APi_Profile_ChangeGender : BloomerRestful

- (instancetype)initWithParams:(profile_change_gender *) params;

@end
