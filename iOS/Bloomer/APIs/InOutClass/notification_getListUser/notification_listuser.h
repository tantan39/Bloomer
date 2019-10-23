//
//  notification_listuser.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/16/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "BaseJSON.h"

@interface notification_listuser : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* accessToken;
@property (strong, nonatomic) NSString* devide_id;
@property (assign, nonatomic) NSInteger user_id;
@property (strong, nonatomic) NSString* noti_key;
@property (assign, nonatomic) NSInteger index;

-(id)initWithAccessToken:(NSString*) token deviceId:(NSString*) device andNoti_key:(NSString*)key index:(NSInteger)index;

@end
