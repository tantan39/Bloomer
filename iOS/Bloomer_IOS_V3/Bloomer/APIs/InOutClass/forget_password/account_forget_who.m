//
//  account_forget_who.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "account_forget_who.h"

@implementation account_forget_who

-(id)initWithField:(NSString*)field countryCode:(NSInteger)countryID{
    self = [super init];
    
    if(self)
    {
        _field = field;
        _countryCode = countryID;
    }
    
    return self;
}

//-(NSString *) createStringJSON
//{
//    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_field, k_FIELD,[NSNumber numberWithInteger:_countryCode],k_COUNTRY_ID, nil];
//    NSError *error;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
//    NSString* result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return result;
//}
- (NSDictionary *)encodeToJSON{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:_field, k_FIELD,[NSNumber numberWithInteger:_countryCode],k_COUNTRY_ID, nil];
    return info;
}

@end
