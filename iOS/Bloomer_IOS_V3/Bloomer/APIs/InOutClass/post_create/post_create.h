//
//  post_create.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "payload.h"

@interface post_create : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (strong, nonatomic) NSMutableArray *payloads;

-(id)initWithAccessToken:(NSString* )access_token device_token:(NSString*)device_token payloads:(NSMutableArray *)payloads;
@end
