//
//  API_Anonymous_ProfileFetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_profile_fetch.h"
#import "APIDefine.h"

@interface API_Anonymous_ProfileFetch : BloomerRestful

- (instancetype)initWithUserID:(NSString *) userID;

@end
