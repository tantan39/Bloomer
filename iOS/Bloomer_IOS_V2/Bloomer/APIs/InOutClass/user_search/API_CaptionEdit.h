//
//  API_CaptionEdit.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "caption_post.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_name_update.h"

@interface API_CaptionEdit : BloomerRestful

- (instancetype)initWithParams:(caption_post *) params;

@end
