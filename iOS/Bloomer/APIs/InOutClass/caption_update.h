//
//  caption_update.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"
#import "BaseJSON.h"

@interface caption_update : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *status;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                   status:(NSString *)status;

@end
