//
//  API_PopupMembership.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_PopupMembership.h"

@interface API_PopupMembership : BloomerRestful

-(id)initWithAccessToken:(NSString*)access_token deviceId:(NSString*)device_id;

@end
