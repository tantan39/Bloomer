//
//  API_Profile_Location.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "location.h"
#import "out_name_update.h"

@interface API_Profile_Location : BloomerRestful

- (instancetype)initWithParams:(location *) params;

@end
