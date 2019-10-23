//
//  API_RaceList.h
//  Bloomer
//
//  Created by Tu Le on 8/1/2017.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_RaceList.h"

@interface API_RaceList : BloomerRestful

- (id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token gender:(NSInteger)gender;
- (id)initWithGender:(NSInteger)gender;

@end
