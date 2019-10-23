//
//  API_Covers_Add.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "covers_add.h"
#import "out_auth_register_verifycode.h"
@interface API_Covers_Add : BloomerRestful

- (instancetype)initWithParams:(covers_add *) params;

@end
