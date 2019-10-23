//
//  API_Notification_Setting.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "BaseJSON.h"
#import "notification_setting.h"
#import "out_name_update.h"

@interface API_Notification_Setting : BloomerRestful

- (instancetype)initWithParams:(notification_setting *) params;

@end
