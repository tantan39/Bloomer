//
//  covers_add.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/21/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "APIDefine.h"
#import "BaseJSON.h"

@interface covers_add : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSMutableArray *photos;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                   photos:(NSMutableArray *)photos;

@end
