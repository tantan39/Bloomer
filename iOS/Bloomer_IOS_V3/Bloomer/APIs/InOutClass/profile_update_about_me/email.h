//
//  email.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/13/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface email : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *email;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token email:(NSString *)email;

@end
