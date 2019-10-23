//
//  API_Check_Pass_User.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "checkPassObject.h"
#import "resultCheckPass.h"

@interface API_Check_Pass_User : BloomerRestful

- (instancetype)initWithParams:(checkPassObject *) params;

@end
