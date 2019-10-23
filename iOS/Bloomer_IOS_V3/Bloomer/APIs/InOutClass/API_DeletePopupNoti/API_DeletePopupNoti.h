//
//  API_DeletePopupNoti.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 11/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "deletePopupNoti.h"

@interface API_DeletePopupNoti : BloomerRestful

-(instancetype)initWithAccessToken:(NSString*)access_token device_id:(NSString*)device_id noti_id:(NSInteger)noti_id addType:(NSInteger)type;

@end
