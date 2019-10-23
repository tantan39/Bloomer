//
//  out_notification_fetch.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "notification.h"

@interface out_notification_fetch : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *notifications;

@end
