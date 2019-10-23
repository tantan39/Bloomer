//
//  caption_post.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface caption_post : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSString *caption;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                  post_id:(NSString *)post_id
                  caption:(NSString *)caption;

@end
