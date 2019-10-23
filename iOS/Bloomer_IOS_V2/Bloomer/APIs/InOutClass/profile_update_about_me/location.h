//
//  location.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface location : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (assign, nonatomic) NSInteger location_id;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString*)device_token locationID:(NSInteger)location_id;

@end
