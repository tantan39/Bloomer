//
//  API_Message_Presence.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_message_presence.h"

@interface API_Message_Presence : BloomerRestful

@property (assign, nonatomic) BOOL isLoadMore;

- (instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token room_id:(NSString*)room_id mid:(NSString*)mid;

- (instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token roster_id:(NSInteger)roster_id mid:(NSString*)mid isLoadMore:(BOOL)isMore;

- (instancetype)initWithAuth_Session:(NSString*)auth_session device_token:(NSString*)device_token roster_id:(NSInteger)roster_id mid:(NSString*)mid;

@end
