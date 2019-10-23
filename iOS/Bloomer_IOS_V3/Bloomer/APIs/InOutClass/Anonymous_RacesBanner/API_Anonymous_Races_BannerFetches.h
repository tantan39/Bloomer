//
//  API_Anonymous_Races_BannerFetches.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/17/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_BannerFetch.h"
@interface API_Anonymous_Races_BannerFetches : BloomerRestful

-(instancetype)initWithGender:(NSInteger)gender
                key:(NSString *)key
               cKey:(NSString *)cKey;

@end
