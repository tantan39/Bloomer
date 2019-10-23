//
//  API_Auth_RegisterCallSupport.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "sendcode.h"
@interface API_Auth_RegisterCallSupport : BloomerRestful

- (instancetype)initWithParams:(sendcode *) params;

@end
