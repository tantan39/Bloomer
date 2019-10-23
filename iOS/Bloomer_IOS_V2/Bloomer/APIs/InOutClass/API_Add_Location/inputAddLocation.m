//
//  inputAddLocation.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "inputAddLocation.h"

@implementation inputAddLocation

- (id)initWithLocation:(NSInteger )location
          access_token:(NSString * )access_token
             device_id:(NSString * )device_id
{
    self = [super init];
    if(self)
    {
        self.location = location;
        self.access_token = access_token;
        self.device_id = device_id;
    }
    return self;
    
}

- (NSDictionary *)encodeToJSON{
    
    NSMutableDictionary *upload = [[NSMutableDictionary alloc] init];
    
    [upload setObject:[NSNumber numberWithInteger:_location] forKey:@"location_id"];
    [upload setObject:_access_token forKey:k_ACCESS_TOKEN];
    [upload setObject:_device_id forKey:k_DEVICE_TOKEN];
    
    return upload;
}

@end
