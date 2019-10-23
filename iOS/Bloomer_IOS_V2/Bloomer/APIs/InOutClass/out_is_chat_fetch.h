//
//  out_is_chat_fetch.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/26/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface out_is_chat_fetch : NSObject<BaseJSON>

@property (assign, nonatomic) BOOL is_chat;
@property (assign, nonatomic) NSInteger remain_flower;

@end
