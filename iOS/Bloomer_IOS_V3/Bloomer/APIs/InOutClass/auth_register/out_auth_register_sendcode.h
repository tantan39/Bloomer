//
//  out_auth_register_sendcode.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
@interface out_auth_register_sendcode : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger m_id;
@property (assign, nonatomic) BOOL status,unverify;

@end
