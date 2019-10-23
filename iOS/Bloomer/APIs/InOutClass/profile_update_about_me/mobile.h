//
//  mobile.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface mobile : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSInteger country_id;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token mobile:(NSString *)mobile country_id:(NSInteger)country_id;

@end
