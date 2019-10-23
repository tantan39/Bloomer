//
//  API_Profile_UpdateUserName.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Profile_UpdateUserName.h"

@implementation API_Profile_UpdateUserName
- (instancetype)initWithParams:(username_update *)params{
    self = [super initWith:[APIDefine profile_usernameLink] Params:[params encodeToJSON]];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_name_update alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_name_update alloc] init];
}
@end
