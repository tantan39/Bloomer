//
//  API_Notification_Pull.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "out_notification_pull.h"

@protocol API_NotificationPullDelegate<NSObject>

- (void)getDataNotification_Pull:(out_notification_pull * )data Response:(RestfulResponse *) response;
@end

@interface API_Notification_Pull : BloomerRestful

-(instancetype)initWithAuth_Session:(NSString *)auth_session device_token:(NSString*)device_token;

@property (weak,nonatomic) id<API_NotificationPullDelegate> delegate;

@end
