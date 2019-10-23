//
//  out_message_pull.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"
#import "message.h"

@interface out_message_pull : NSObject<BaseJSON>

@property (strong, nonatomic) NSMutableArray *messages;
@property (assign, nonatomic) NSInteger notification;
@property (weak, nonatomic) NSString* redirect_url;
@property (strong, nonatomic) NSMutableArray *messages_read;
@property (assign, nonatomic) BOOL isBlock;
@property (assign, nonatomic) NSInteger blocker;
@property (assign, nonatomic) NSString* blockMessage;

@end
