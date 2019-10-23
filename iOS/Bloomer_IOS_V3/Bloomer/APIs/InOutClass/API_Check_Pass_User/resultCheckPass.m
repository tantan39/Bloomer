//
//  resultCheckPass.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "resultCheckPass.h"

@implementation resultCheckPass

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        
        _isSetPass = [[json objectForKey:@"check_pass_user"] boolValue];
        
    }
    return self;
}

@end
