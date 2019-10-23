//
//  blocker.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/11/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "blocker.h"

@implementation blocker

//-(void)extractData:(NSDictionary*) data
//{
//    _uid = [[data objectForKey:k_UID] integerValue];
//
//    _screen_name = [data objectForKey:k_SCREEN_NAME];
//    // encode for EMOJI character
////    NSData *nameData = [[data objectForKey:k_NAME] dataUsingEncoding:NSUTF8StringEncoding];
////    _screen_name = [[NSString alloc] initWithData:nameData encoding:NSNonLossyASCIIStringEncoding];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _uid = [[json objectForKey:k_UID] integerValue];
        
        _screen_name = [json objectForKey:k_SCREEN_NAME];
    }
    return self;
}

@end
