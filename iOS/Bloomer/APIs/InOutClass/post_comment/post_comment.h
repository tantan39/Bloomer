//
//  post_comment.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface post_comment : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *access_token;
@property (weak, nonatomic) NSString *device_token;
@property (weak, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *comment;

-(id)initWithAccessToken:(NSString *)access_token
            device_token:(NSString *)device_token
                 post_id:(NSString *)post_id
                 comment:(NSString *)comment;

@end
