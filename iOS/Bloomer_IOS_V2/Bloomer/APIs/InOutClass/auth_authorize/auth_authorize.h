//
//  auth_authorize.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/8/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface auth_authorize : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *credential;
@property (strong, nonatomic) NSString *secret_client;
@property (strong, nonatomic) NSString *device_token;
@property (assign, nonatomic) NSInteger country_id;
@property (assign, nonatomic) NSInteger app_id;
@property (strong, nonatomic) NSString* notification_token;

-(id)initWithCredential:(NSString*)credential
           secretClient:(NSString*)secret_client
            deviceToken:(NSString*)device_token
             country_id:(NSInteger)country_id
                  appID:(NSInteger)app_id
     notification_token:(NSString*)notification_token;


//- (NSDictionary *) createStringJSON;
@end
