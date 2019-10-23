//
//  out_location_load.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/22/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_location_load.h"
#import "city.h"
#import "comment.h"

@implementation out_location_load
@synthesize citys;

//- (void)extractData:(NSDictionary *)data {
//    citys = [[NSMutableArray alloc] init];
//    
//    NSArray *output = [data objectForKey:k_CITIES];
//    
//    NSInteger n = [output count];
//    
//    for (NSInteger i = 0 ; i< n ; i++)
//    {
//        NSDictionary *temp = [output objectAtIndex:i];
//        
//        city *newCity = [[city alloc] init];
//        [newCity extractData:temp];
//        
//        [citys addObject:newCity];
//    }
//    
//    _status = [[data objectForKey:k_STATUS] boolValue];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        citys = [[NSMutableArray alloc] init];
        
        NSArray *output = [json objectForKey:k_CITIES];
        
        NSInteger n = [output count];
        
        for (NSInteger i = 0 ; i< n ; i++)
        {
            NSDictionary *temp = [output objectAtIndex:i];
            
            city *newCity = [[city alloc] initWithJSON:temp];
//            [newCity extractData:temp];
            
            [citys addObject:newCity];
        }
        
        _status = [[json objectForKey:k_STATUS] boolValue];
    }
    return self;
}

@end
