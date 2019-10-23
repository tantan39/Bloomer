//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "JSON_WinnersClub.h"

@interface API_WinnersClub : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      gsb:(NSInteger)gsb gender:(NSInteger)gender uid:(NSNumber *)uid;

@end
