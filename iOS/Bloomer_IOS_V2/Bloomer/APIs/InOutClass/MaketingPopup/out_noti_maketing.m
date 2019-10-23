//
//  out_noti_maketing.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 4/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "out_noti_maketing.h"

@implementation out_noti_maketing

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        NSArray *popUps = [json objectForKey:@"data"];
    }
    return self;
}

@end
