//
//  API_Get_RewardMemebership.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "RewardMembership.h"

@interface API_Get_RewardMemebership : BloomerRestful

-(instancetype) initWithAccessToken:(NSString*) token deviceId:(NSString*) device andUserId:(NSInteger )uid;

@end
