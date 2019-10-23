//
//  API_IsChat_Fetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_is_chat_fetch.h"

@interface API_IsChat_Fetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
               andUserId:(NSString *)uid;

@end
