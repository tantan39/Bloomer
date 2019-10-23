//
//  API_GalleriesLoad.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/10/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_photo_load_link.h"

@interface API_GalleriesLoad : BloomerRestful

-(instancetype) initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token userID:(NSString*)Uid;

@end
