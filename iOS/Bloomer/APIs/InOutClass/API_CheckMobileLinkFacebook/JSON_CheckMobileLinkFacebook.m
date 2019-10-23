//
//  JSON_CheckMobileLinkFacebook.m
//  Bloomer
//
//  Created by Steven on 3/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_CheckMobileLinkFacebook.h"

@implementation JSON_CheckMobileLinkFacebook

- (instancetype)initWithJSON:(NSDictionary *)json
{
    self = [super init];
    if (self)
    {
        self.linkedFacebook = [[json objectForKey:@"is_linkFB"] boolValue];
        self.existed = [[json objectForKey:@"is_exist"] boolValue];
    }
    
    return self;
}

@end
