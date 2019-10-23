//
//  API_BlockRemove.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "block_remove.h"
#import "out_auth_register_verifycode.h"

@interface API_BlockRemove : BloomerRestful

- (instancetype)initWithParams:(block_remove *) params;
@end
