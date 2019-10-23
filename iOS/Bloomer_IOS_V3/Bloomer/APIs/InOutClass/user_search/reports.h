//
//  reports.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface reports : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;

@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger reason_id;
@property (strong, nonatomic) NSString *reason_other;

- (id)initWithAccess_Token:(NSString *)access_token
              device_token:(NSString*)device_token
                       uid:(NSInteger)uid
                 reason_id:(NSInteger)reason_id
               reasonOther:(NSString *)reason_other;

@end
