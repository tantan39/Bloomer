//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "JSON_RacesNameFetch.h"

@interface API_AnonymousRaceName : BloomerRestful

- (id)initWithKey:(NSString *)key gender:(NSInteger)gender;

@end
