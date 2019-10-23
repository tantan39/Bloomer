//
//  deleteConversionData.h
//  Bloomer
//
//  Created by Le Chau Tu on 3/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BaseJSON.h"
#import "APIDefine.h"

@interface deleteConversionData : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_id;
@property (assign, nonatomic) NSInteger roster_id;

-(id)initWithAccessToken:(NSString*)access_token deviceId:(NSString*)device_id rosterId:(NSInteger)roster_id;

@end
