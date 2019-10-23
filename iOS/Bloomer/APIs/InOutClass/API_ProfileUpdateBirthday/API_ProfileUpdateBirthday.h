//
//  API_ProfileUpdateBirthday.h
//  Bloomer
//
//  Created by Steven on 10/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "out_name_update.h"

@interface API_ProfileUpdateBirthday : BloomerRestful

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken birthday:(NSString*)birthday;

@end
