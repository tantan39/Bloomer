//
//  API_Profile_ChangeMobile.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "mobile.h"
#import "out_name_update.h"

@interface API_Profile_ChangeMobile : BloomerRestful

- (instancetype)initWithParams:(mobile *) params;

@end
