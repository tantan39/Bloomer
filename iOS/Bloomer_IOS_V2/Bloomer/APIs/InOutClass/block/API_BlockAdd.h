//
//  API_BlockAdd.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "block_add.h"
#import "out_auth_register_verifycode.h"
@interface API_BlockAdd : BloomerRestful
- (instancetype)initWithParams:(block_add *) params;
@end
