//
//  notification_user.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BaseJSON.h"

@interface notification_user : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* avatar;
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger gaveNumber;

@end
