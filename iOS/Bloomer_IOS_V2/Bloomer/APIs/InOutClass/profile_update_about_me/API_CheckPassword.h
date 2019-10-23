//
//  API_CheckPassword.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "check_password.h"
#import "out_name_update.h"

@interface API_CheckPassword : BloomerRestful

- (instancetype)initWithParams:(check_password *) params;


@end
