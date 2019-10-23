//
//  API_CheckPhoneExist.h
//  Bloomer
//
//  Created by Le Chau Tu on 11/27/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_CheckPhoneExist.h"

@interface API_CheckPhoneExist : BloomerRestful

-(instancetype)initWithPhoneNumber:(NSString*)phone_number country_id:(NSInteger)country_id device_id:(NSString*)device_id;

@end
