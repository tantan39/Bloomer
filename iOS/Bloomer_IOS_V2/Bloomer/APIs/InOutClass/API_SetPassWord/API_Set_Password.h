//
//  API_Set_Password.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "password.h"
#import "out_name_update.h"

@interface API_Set_Password : BloomerRestful

- (instancetype)initWithParams:(password *) params;

@end
