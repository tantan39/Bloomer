//
//  access_code.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "access_code.h"

@implementation access_code

- (id)initWithDeviceToken:(NSString *)device_token access_code:(NSString *)access_token {
    self = [super init];
    
    if (self) {
        _device_token = device_token;
        _access_code = access_token;
    }
    
    return self;
}

//- (NSString *)createStringJSON {
//    NSDictionary *upload = [NSDictionary dictionaryWithObjectsAndKeys:_device_token, k_DEVICE_TOKEN, _access_code,@"access_code", nil];
//    
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:upload options:NSJSONWritingPrettyPrinted error:&error];
//    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *upload = [NSDictionary dictionaryWithObjectsAndKeys:_device_token, k_DEVICE_TOKEN, _access_code,@"access_code", nil];
    
    return upload;
}
@end
