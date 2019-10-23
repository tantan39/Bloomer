//
//  API_ClosedRaceFeed.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_ClosedRaceFeed.h"

@interface API_ClosedRaceFeed : BloomerRestful

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                  gender:(NSInteger)gender;

-(id)initWithKey:(NSString *)key
                  gender:(NSInteger)gender;

@end
