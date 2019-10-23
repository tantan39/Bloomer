//
//  out_photo_load_photoid.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/24/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "out_photo_load_photoid.h"

@implementation out_photo_load_photoid

@synthesize photoid;

- (void)extractData:(NSDictionary *)data {
    
    photoid = [[NSMutableArray alloc] init];
    NSArray *output = [data objectForKey:@"photos"];
    
    NSInteger n = [output count];
    
    for(NSInteger i = 0; i < n; i++) {
        //NSString *temp = [output objectAtIndex:i];
        NSDictionary *temp = [output objectAtIndex:i];
        NSString *photo = [temp objectForKey:@"photo_id"];
        [photoid addObject:photo];
    }
}


@end
