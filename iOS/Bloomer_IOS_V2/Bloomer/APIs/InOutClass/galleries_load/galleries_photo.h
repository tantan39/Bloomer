//
//  galleries_photo.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 7/30/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
//#import "jsonAbstractClassProtected.h"

@interface galleries_photo : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *photoLink;
@property (strong, nonatomic) NSString *photo_id;

@end
