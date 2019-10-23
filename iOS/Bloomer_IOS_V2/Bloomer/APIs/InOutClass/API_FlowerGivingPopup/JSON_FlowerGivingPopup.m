//
//  JSON_FlowerGivingPopup.m
//  Bloomer
//
//  Created by Tan Tan on 4/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "JSON_FlowerGivingPopup.h"

@implementation JSON_FlowerGivingPopup

- (instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        NSDictionary * data = [json objectForKey:@"data"];
        self.type = [[data objectForKey:@"type"] integerValue];
    }
    return self;
}
@end
