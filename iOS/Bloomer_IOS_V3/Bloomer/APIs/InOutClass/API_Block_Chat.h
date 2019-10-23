//
//  API_Block_Chat.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "BaseJSON.h"
#import "out_block_chat.h"

@interface API_Block_Chat : BloomerRestful

-(instancetype)initWithAccessToken:(NSString*)access_token device_id:(NSString*)device_id block_id:(NSInteger)block_id addBlock:(BOOL)isAddBlock;

@end
