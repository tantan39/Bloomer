//
//  API_AccessCode.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "access_code.h"
#import "out_name_update.h"

@interface API_AccessCode : BloomerRestful

- (instancetype)initWithParams:(access_code *) params;

@end
