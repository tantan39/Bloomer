//
//  API_Add_Location.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_name_update.h"
#import "inputAddLocation.h"

@interface API_Add_Location : BloomerRestful

- (instancetype)initWithParams:(inputAddLocation *) params;

@end
