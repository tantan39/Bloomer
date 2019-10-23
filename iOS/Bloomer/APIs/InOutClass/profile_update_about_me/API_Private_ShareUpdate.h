//
//  API_Private_ShareUpdate.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "private_share.h"
#import "out_name_update.h"

@interface API_Private_ShareUpdate : BloomerRestful

- (instancetype)initWithParams:(private_share *) params;

@end
