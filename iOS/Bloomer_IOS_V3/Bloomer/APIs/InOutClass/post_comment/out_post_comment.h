//
//  out_post_comment.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_post_comment : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *comment_id;

@end
