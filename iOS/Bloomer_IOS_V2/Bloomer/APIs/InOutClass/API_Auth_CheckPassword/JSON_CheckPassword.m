//
//  JSON_CheckPassword.m
//  Bloomer
//
//  Created by Tan Tan on 3/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_CheckPassword.h"

@implementation JSON_CheckPassword

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if(self) {
        _check_pass_user = [[json objectForKey:@"check_pass_user"] boolValue];
    }
    return self;
}

@end
