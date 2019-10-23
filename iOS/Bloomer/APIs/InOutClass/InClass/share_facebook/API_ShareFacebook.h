//
//  API_ShareFacebook.h
//  Bloomer
//
//  Created by Steven on 12/10/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Json_ShareFacebook.h"
#import "BloomerRestful.h"

@interface API_ShareFacebook : BloomerRestful

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token isPopup:(BOOL)isPopup;

@end
