//
//  out_notification_pull.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/17/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
//#import "jsonAbstractClassProtected.h"
#import "APIDefine.h"
#import "BaseJSON.h"
@interface out_notification_pull : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger notification;
@property (assign, nonatomic) NSInteger message;
@property (assign, nonatomic) NSInteger total;
@property (strong, nonatomic) NSMutableArray* rooms;
@property (weak, nonatomic) NSString* redirect_url;
@property (assign, nonatomic) NSInteger isFreshRace;
@property (strong, nonatomic) NSString* popup;

@end
