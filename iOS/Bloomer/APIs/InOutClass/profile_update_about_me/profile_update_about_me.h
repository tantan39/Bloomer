//
//  profile_update_about_me.h
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/18/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface profile_update_about_me : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* access_token;
@property (strong, nonatomic) NSString* device_token;
@property (strong, nonatomic) NSString* about_me;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
             andAbout_me:(NSString *)me;

@end
