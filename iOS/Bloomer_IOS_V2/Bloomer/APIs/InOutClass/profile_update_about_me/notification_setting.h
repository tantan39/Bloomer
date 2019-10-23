//
//  notification_setting.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"
@interface notification_setting : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (assign, nonatomic) BOOL notifications;
@property (assign, nonatomic) BOOL chat;
@property  BOOL follow;
@property (assign, nonatomic) BOOL flower;
@property (assign, nonatomic) BOOL app;
@property (assign, nonatomic) BOOL race;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token notification:(BOOL)notification chat:(BOOL)chat follow:(BOOL)follow flower:(BOOL)flower app:(BOOL)app race:(BOOL)race;


@end
