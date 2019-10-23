//
//  API_PostCreate.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "post_create.h"
#import "out_post_create.h"

@interface API_PostCreate : BloomerRestful

- (instancetype) initWithParam:(post_create *) param;

@end
