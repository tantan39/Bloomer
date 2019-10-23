//
//  API_NotiMarketing
//  Bloomer
//
//  Created by Tu Le on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_PopUpMarketing.h"

@interface API_NotiMarketing : BloomerRestful

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token;

@end
