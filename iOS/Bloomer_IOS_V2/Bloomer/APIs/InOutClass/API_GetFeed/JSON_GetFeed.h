//
//  JSON_GetFeed.h
//  Bloomer
//
//  Created by Tan Tan on 8/13/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "out_content_post.h"

@interface JSON_GetFeed : NSObject <BaseJSON>
@property (strong,nonatomic) NSMutableArray * posts;
@end
