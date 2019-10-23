//
//  private_share.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"
#import "BaseJSON.h"

@interface private_share : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (assign, nonatomic) BOOL allow_share;

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token allow_share:(BOOL)allow_share;

@end
