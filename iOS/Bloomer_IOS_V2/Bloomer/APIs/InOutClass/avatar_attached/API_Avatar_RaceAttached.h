//
//  API_Avatar_RaceAttached.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_avatar_attached.h"
#import "BaseJSON.h"
@interface API_Avatar_RaceAttached : BloomerRestful

-(instancetype)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token image:(UIImage*)image key:(NSString *)key;

@end
