//
//  out_notification_listUser.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "notification_user.h"


@interface out_notification_listUser : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray* listUser;
@property (assign, nonatomic) NSInteger index;

-(id) init;

@end
