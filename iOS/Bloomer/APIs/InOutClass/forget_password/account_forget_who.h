//
//  account_forget_who.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface account_forget_who : NSObject<BaseJSON>

@property (strong, nonatomic) NSString* field;
@property (assign, nonatomic) NSInteger countryCode;

-(id)initWithField:(NSString*)field countryCode:(NSInteger)countryID;

@end

