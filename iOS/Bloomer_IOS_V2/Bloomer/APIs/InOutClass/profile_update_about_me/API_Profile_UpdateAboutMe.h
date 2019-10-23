//
//  API_Profile_UpdateAboutMe.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/28/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "profile_update_about_me.h"
#import "out_profile_update.h"

@interface API_Profile_UpdateAboutMe : BloomerRestful

- (instancetype)initWithParams:(profile_update_about_me *) params;

@end
