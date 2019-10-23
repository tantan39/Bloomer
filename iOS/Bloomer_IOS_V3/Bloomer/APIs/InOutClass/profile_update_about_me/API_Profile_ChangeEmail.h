//
//  API_Profile_ChangeEmail.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "email.h"
#import "out_name_update.h"

@interface API_Profile_ChangeEmail : BloomerRestful

- (instancetype)initWithParams:(email *) params;

@end
