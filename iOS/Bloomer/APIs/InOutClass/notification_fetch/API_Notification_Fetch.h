//
//  API_Notification_Fetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_notification_fetch.h"

@interface API_Notification_Fetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token notification_id:(NSString*)notification_id;

@end
