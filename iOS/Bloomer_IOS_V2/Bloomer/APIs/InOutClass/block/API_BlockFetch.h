//
//  API_BlockFetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_block_fetch.h"
@interface API_BlockFetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;


@end
