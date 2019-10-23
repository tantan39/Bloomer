//
//  gender.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/28/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface genders : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (assign, nonatomic) NSInteger gender;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token gender:(NSInteger)gender;

@end
