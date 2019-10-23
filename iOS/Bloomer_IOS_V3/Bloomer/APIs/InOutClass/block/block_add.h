//
//  block_add.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/8/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

//#import "jsonAbstractClass.h"
#import "APIDefine.h"
#import "BaseJSON.h"

@interface block_add : NSObject <BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (assign, nonatomic) NSInteger uid;

-(id)initWithAccessToken:(NSString*)access_token device_token:(NSString*)device_token uid:(NSInteger)uid;

@end
