//
//  API_BlockLists_Fetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_blocklists_fetches.h"
@interface API_BlockLists_Fetches : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token;

@end
