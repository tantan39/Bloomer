//
//  out_avatar_attached.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/12/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_avatar_attached : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *photo_url;

@end
