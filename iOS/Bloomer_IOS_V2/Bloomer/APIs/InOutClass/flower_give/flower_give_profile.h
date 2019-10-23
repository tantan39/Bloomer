//
//  flower_give_profile.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
@interface flower_give_profile : NSObject<BaseJSON>

@property (weak, nonatomic) NSString *access_token;
@property (weak, nonatomic) NSString *device_token;
@property (assign, nonatomic) long long num_flower;
@property (assign, nonatomic) NSInteger receiver;

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
               num_flower:(long long)num_flower
                 receiver:(NSInteger)receiver;
@end
