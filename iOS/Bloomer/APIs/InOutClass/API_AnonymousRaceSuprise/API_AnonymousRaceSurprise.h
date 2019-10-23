//
//  API_PostUserFetches.h
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "JSON_RacesFetch.h"

@interface API_AnonymousRaceSurprise : BloomerRestful

- (id)initWithKey:(NSString *)key ckey:(NSString *)ckey gender:(NSInteger)gender;

@end
