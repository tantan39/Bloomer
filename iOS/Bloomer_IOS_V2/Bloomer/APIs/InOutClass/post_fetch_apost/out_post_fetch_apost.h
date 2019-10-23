//
//  out_post_fetch_apost.h
//  DemoForAPI
//
//  Created by Nguyen Thanh Tu on 12/15/14.
//  Copyright (c) 2014 Nguyen Thanh Tu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
//#import "post_detail.h"
#import "BaseJSON.h"
#import "APIDefine.h"
#import "post_detail.h"

@interface out_post_fetch_apost : NSObject<BaseJSON>

@property (strong, nonatomic) post_detail *aPost;

@end
