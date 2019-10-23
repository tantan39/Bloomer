//
//  API_Notification_ListUser.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "notification_listuser.h"
#import "out_notification_listUser.h"

@interface API_Notification_ListUser : BloomerRestful

- (instancetype)initWithParam:(notification_listuser *) param;

@end
