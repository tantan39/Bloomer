//
//  API_Profile_UpdateStatus.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "caption_update.h"
#import "out_name_update.h"
@interface API_Profile_UpdateStatus : BloomerRestful

- (instancetype)initWithParams:(caption_update *) params;


@end
