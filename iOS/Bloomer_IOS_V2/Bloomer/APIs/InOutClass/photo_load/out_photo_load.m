//
//  out_photo_load.m
//  Xinh
//
//  Created by Nguyen Thanh Tu on 12/30/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "out_photo_load.h"

@implementation out_photo_load

@synthesize imageLink;

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [ super init];
    if (self) {
        imageLink = [[NSMutableArray alloc] init];
        NSArray *output = [json objectForKey:k_PHOTOS];
        
        NSInteger n = [output count];
        
        for(NSInteger i = 0; i < n; i++) {
            NSString *temp = [output objectAtIndex:i];
            
            [imageLink addObject:temp];
        }
    }
    return self;
}

@end
