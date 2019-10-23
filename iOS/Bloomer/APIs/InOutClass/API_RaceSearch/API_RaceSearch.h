//
//  API_RaceSearch.h
//  Bloomer
//
//  Created by Le Chau Tu on 8/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_RaceSearch.h"

@interface API_RaceSearch : BloomerRestful

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                    ckey:(NSString *)ckey
                  gender:(NSInteger)gender
                    term:(NSString *)term
                    page:(NSInteger)page
                    size:(NSInteger)size;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                     key:(NSString *)key
                    ckey:(NSString *)ckey
                  gender:(NSInteger)gender
                    term:(NSString *)term;

@end
