//
//  report.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "APIDefine.h"

@interface report : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;

@property (strong, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger reason_id;
@property (strong, nonatomic) NSString *reason_other;

- (id)initWithAccess_Token:(NSString *)access_token
              device_token:(NSString*)device_token
                    postID:(NSString *)post_id
                 reason_id:(NSInteger)reason_id
               reasonOther:(NSString *)reason_other;

@end
