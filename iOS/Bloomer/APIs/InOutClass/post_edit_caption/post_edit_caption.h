//
//  post_edit_caption.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 5/19/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "jsonAbstractClass.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface post_edit_caption : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* access_token;
@property (weak, nonatomic) NSString* device_token;
@property (weak, nonatomic) NSString* post_id;
@property (strong, nonatomic) NSString* content_post;

-(id)initWithAccessToken:(NSString*)access_token Device_Token:(NSString*)device_token Post_ID:(NSString*)post_id Content_Post:(NSString*)content_post;

@end
