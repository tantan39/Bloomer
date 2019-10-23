//
//  JSON_UserRacePosts.h
//  Bloomer
//
//  Created by Steven on 4/2/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "out_content_post.h"

@interface JSON_UserRacePosts : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *posts;

@end
