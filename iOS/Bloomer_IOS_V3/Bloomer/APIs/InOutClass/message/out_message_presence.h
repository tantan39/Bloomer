//
//  out_message_presence.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "message.h"
#import "BaseJSON.h"

@interface out_message_presence : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) NSString* redirect_url;
@property (assign, nonatomic) BOOL is_block;
@property (strong, nonatomic) NSString* blockMessage;
@property (assign, nonatomic) NSInteger blocker;

@end

