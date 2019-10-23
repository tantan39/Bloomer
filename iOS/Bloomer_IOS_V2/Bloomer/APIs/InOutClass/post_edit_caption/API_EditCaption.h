//
//  API_EditCaption.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/26/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "post_edit_caption.h"
#import "out_auth_register_verifycode.h"
@interface API_EditCaption : BloomerRestful

- (instancetype)initWithParams:(post_edit_caption *) params;

@end
