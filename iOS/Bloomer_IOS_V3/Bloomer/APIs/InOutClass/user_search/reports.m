//
//  reports.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "reports.h"

@implementation reports

- (id)initWithAccess_Token:(NSString *)access_token device_token:(NSString *)device_token uid:(NSInteger)uid reason_id:(NSInteger)reason_id reasonOther:(NSString *)reason_other {
    self = [super init];
    if(self)
    {
        _access_token = access_token;
        _device_token = device_token;
        _uid = uid;
        _reason_id = reason_id;
        _reason_other = reason_other;
    }
    return self;
}

- (NSString *)createStringJSON {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setObject:[NSNumber numberWithInteger:_reason_id] forKey:@"reason_id"];
    [payload setObject:[NSNumber numberWithInteger:_uid]forKey:k_UID];
    [payload setObject:_reason_other forKey:@"reason_other"];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:payload forKey:k_PAYLOAD];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSDictionary *)encodeToJSON{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithObjectsAndKeys:_access_token, k_ACCESS_TOKEN, _device_token, k_DEVICE_TOKEN, nil];
    
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setObject:[NSNumber numberWithInteger:_reason_id] forKey:@"reason_id"];
    [payload setObject:[NSNumber numberWithInteger:_uid]forKey:k_UID];
    [payload setObject:_reason_other forKey:@"reason_other"];
    
    [dictionary setObject:auth forKey:k_AUTH];
    [dictionary setObject:payload forKey:k_PAYLOAD];
    
    return dictionary;
}

@end
