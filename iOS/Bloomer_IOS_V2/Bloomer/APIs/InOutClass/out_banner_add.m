//
//  out_banner_add.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "out_banner_add.h"

@implementation out_banner_add

//- (void)extractData:(NSDictionary *)data
//{
//    _bannerList = [data objectForKey:k_BANNER];
//}

- (instancetype)initWithJSON:(NSDictionary *)json{
    
    self = [super init];
    if (self) {
        _bannerList = [json objectForKey:k_BANNER];
    }
    return self;
}

@end
