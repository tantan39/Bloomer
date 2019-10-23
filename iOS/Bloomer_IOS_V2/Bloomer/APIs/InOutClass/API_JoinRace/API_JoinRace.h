//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_JoinRace.h"

@interface API_JoinRace : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      key:(NSString *)key photoID:(NSString *)photoID;

@end


@interface API_CheckJoinRace : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      key:(NSString *)key;

@end
