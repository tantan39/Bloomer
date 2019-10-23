//
//  location.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "location.h"

@implementation location

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token locationID:(NSInteger)location_id {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _location_id = location_id;
    }
    return self;
}

//-(NSString *)createStringJSON {
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
//    
//    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
//    [profile setObject:[NSNumber numberWithInteger:_location_id] forKey:k_LOCATION_ID];
//    
//    [dictionary setObject:auth forKey:k_AUTH];
//    [dictionary setObject:profile forKey:k_PROFILE];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
    NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
    [profile setObject:[NSNumber numberWithInteger:_location_id] forKey:k_LOCATION_ID];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:profile forKey:k_PROFILE];
    
    return dictionary;
}

@end
