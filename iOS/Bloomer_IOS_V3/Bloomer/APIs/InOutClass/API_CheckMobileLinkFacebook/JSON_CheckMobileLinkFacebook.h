//
//  JSON_CheckMobileLinkFacebook.h
//  Bloomer
//
//  Created by Steven on 3/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface JSON_CheckMobileLinkFacebook : NSObject<BaseJSON>

@property (assign, nonatomic) BOOL linkedFacebook;
@property (assign, nonatomic) BOOL existed;

@end
