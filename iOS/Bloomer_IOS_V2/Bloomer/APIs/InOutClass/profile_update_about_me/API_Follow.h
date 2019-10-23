//
//  API_Follow.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "block_remove.h"
#import "out_name_update.h"

@interface API_UnFollow : BloomerRestful

- (instancetype)initWithParams:(block_remove *) params;

@end


@interface API_ReFollow : BloomerRestful

- (instancetype)initWithParams:(block_remove *) params;

@end
