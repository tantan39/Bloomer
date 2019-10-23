//
//  API_Profile_ChangingGender.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "genders.h"
#import "out_name_update.h"

@interface API_Profile_ChangingGender : BloomerRestful

- (instancetype)initWithParams:(genders *) params;

@end
