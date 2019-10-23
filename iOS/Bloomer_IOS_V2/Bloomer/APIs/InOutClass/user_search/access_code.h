//
//  access_code.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"
#import "BaseJSON.h"

@interface access_code : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *access_code;

- (id)initWithDeviceToken:(NSString *)device_token
              access_code:(NSString *)access_token;

@end
