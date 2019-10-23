//
//  API_LoadPrevousRace.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "JSON_RacesFetch.h"

NS_ASSUME_NONNULL_BEGIN

@interface API_LoadPrevousRace : BloomerRestful
- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                      key:(NSString *)key
                     ckey:(NSString *)ckey
                     rank:(NSInteger)rank
                   gender:(NSInteger)gender
                   scroll:(NSInteger) scroll;
@end

NS_ASSUME_NONNULL_END
