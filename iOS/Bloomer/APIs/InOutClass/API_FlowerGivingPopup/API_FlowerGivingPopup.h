//
//  API_FlowerGivingPopup.h
//  Bloomer
//
//  Created by Tan Tan on 4/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_FlowerGivingPopup.h"
@interface API_FlowerGivingPopup : BloomerRestful

- (instancetype) initWithAccessToken:(NSString *) accessToken DeviceToken:(NSString *) deviceToken;

@end
