//
//  covers.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface covers : NSObject<BaseJSON>

@property (assign, nonatomic) BOOL isCrop;
@property (strong, nonatomic) NSString* pLarge;
@property (strong, nonatomic) NSString* photo_id;
@property (strong, nonatomic) NSString* pCover;

@end
