//
//  out_account_forget_who.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@interface out_account_forget_who : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger f_id;

@end
