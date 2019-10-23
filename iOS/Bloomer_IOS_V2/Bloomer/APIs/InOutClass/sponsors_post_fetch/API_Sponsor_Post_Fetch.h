//
//  API_Sponsor_Post_Fetch.h
//  Bloomer
//
//  Created by Tran Thai Tan on 10/6/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "out_sponsor_fetch.h"
@interface API_Sponsor_Post_Fetch : BloomerRestful

-(instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token post_id:(NSString*)post_id min:(NSInteger)minValue max:(NSInteger)maxValue;

@end
