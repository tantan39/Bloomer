//
//  API_PostComment.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "post_comment.h"
#import "BaseJSON.h"
#import "out_post_comment.h"
@interface API_PostComment : BloomerRestful

- (instancetype)initWithParam:(post_comment *) param;

@end
