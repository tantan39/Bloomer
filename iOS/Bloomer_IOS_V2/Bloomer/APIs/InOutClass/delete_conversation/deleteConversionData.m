//
//  deleteConversionData.m
//  Bloomer
//
//  Created by Le Chau Tu on 3/31/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "deleteConversionData.h"

@implementation deleteConversionData

-(id)initWithAccessToken:(NSString *)access_token deviceId:(NSString *)device_id rosterId:(NSInteger)roster_id {
    if(self = [super init]) {
        self.access_token = access_token;
        self.device_id = device_id;
        self.roster_id = roster_id;
    }
    return self;
}

//-(NSString*)createStringJSON {
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.access_token, k_ACCESS_TOKEN, self.device_id, k_DEVICE_TOKEN, @(self.roster_id), k_ROSTER_ID, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.access_token, k_ACCESS_TOKEN, self.device_id, k_DEVICE_TOKEN, @(self.roster_id), k_ROSTER_ID, nil];

    return dic;
}

@end
