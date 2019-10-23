//
//  API_Rooms_Fetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/21/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_rooms_fetch.h"

@interface API_Rooms_Fetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token room_id:(NSString*)room_id limit:(NSInteger)limit;

@end
