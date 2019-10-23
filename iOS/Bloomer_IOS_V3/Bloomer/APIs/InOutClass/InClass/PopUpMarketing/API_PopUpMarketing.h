//
//  API_PopUpMarketing.h
//  Bloomer
//
//  Created by Steven on 4/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_PopUpMarketing.h"

@interface API_PopUpMarketing : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token;

@end
