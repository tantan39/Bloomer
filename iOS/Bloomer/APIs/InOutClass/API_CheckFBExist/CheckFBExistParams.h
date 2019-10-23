//
//  CheckFBExistParams.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface CheckFBExistParams : NSObject<BaseJSON>

@property (nonatomic, strong) NSString* fb_token;
@property (nonatomic, strong) NSString* device_id;
@property (nonatomic, strong) NSString* notification_token;
@property (nonatomic, assign) NSInteger app_id;

-(id)initWithFBToken:(NSString*)fb_token device_id:(NSString*)device_id app_id:(NSInteger)app_id notification_token:(NSString*)notification_token;

@end
