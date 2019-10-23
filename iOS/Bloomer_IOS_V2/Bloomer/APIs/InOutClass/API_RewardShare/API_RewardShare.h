//
//  API_RewardShare.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 1/4/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "rewardShare.h"

@interface API_RewardShare : BloomerRestful

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken shareID:(NSString*)shareID isPopup:(BOOL)isPopup;

@end
