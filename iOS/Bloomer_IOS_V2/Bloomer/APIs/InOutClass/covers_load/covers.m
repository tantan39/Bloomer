//
//  covers.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "covers.h"

@implementation covers

- (instancetype)initWithJSON:(NSDictionary *)json{
    self = [super init];
    if (self) {
        _isCrop = [[json objectForKey:k_IS_CROP] boolValue];
        _pLarge = [json objectForKey:k_P_LARGE];
        
        if ([json objectForKey:k_PHOTO_ID] != [NSNull null])
        {
            _photo_id = [json objectForKey:k_PHOTO_ID];
        }
        else
        {
            _photo_id = @"";
        }
        
        _pCover = [json objectForKey:k_P_COVER];
    }
    return self;
}

@end
