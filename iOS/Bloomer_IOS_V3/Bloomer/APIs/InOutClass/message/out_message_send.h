//
//  out_message_send.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/2/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_message_send : NSObject<BaseJSON>

@property (weak, nonatomic) NSString* message_id;
@property (assign, nonatomic) BOOL isConnected;
@property (assign, nonatomic) NSInteger sent;
@property (weak, nonatomic) NSString* redirec_uri;

@end
