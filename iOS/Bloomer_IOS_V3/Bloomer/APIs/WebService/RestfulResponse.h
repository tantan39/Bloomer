//
//  RestfulResponse.h
//  Bloomer
//
//  Created by Tran Thai Tan on 7/24/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"
#import "AppHelper.h"

@interface RestfulResponse : NSObject<BaseJSON>

@property NSInteger code;
@property NSInteger expireTime;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString * nameError;
@property (strong, nonatomic) NSString * emailError;
@property (strong, nonatomic) NSString * phoneError;
@property BOOL status, isExpired;

@end
