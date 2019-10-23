//
//  checkPassObject.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "checkPassObject.h"

@implementation checkPassObject

- (id)initWithMobile:(NSString *)mobile
              app_id:(NSInteger )app_id
          country_id:(NSInteger )country
{
    self = [super init];
    if(self)
    {
        _mobile = mobile;
        _app_id = app_id;
        _country_id = country;
    }
    return self;
}

- (NSDictionary *)encodeToJSON{
    
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    
    [upload setObject:_mobile forKey:@"mobile"];
    [upload setObject:[NSNumber numberWithInteger:_app_id] forKey:k_APP_ID];
    [upload setObject:[NSNumber numberWithInteger:_country_id] forKey:k_COUNTRY_ID];
    
    return upload;
}

@end
