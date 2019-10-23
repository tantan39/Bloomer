//
//  API_Setting_Update.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "setting_update.h"
#import "out_auth_register_verifycode.h"
@interface API_Setting_Update : BloomerRestful
- (instancetype)initWithParams:(setting_update *) params;
@end
