//
//  account_forget_verifycode.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/10/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "account_forget_verifycode.h"

@implementation account_forget_verifycode

-(id)initWithF_ID:(NSInteger)f_id active_code:(NSString*)active_code
{
    self = [super init];
    
    if(self)
    {
        _f_id = f_id;
        _active_code = active_code;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_f_id], k_F_ID, _active_code, k_ACTIVE_CODE, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}

- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_f_id], k_F_ID, _active_code, k_ACTIVE_CODE, nil];

    return info;
}
@end
