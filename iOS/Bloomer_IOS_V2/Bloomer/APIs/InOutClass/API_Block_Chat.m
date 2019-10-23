//
//  API_Block_Chat.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Block_Chat.h"

@implementation API_Block_Chat

- (instancetype)initWithAccessToken:(NSString *)access_token device_id:(NSString *)device_id block_id:(NSInteger)block_id addBlock:(BOOL)isAddBlock{
    
    RequestURL* link;
    if(isAddBlock) {
        link = [APIDefine blockChat_addLink];
    } else {
        link = [APIDefine blockChat_removeLink];
    }
    
//    access_token=...&device_id=...&block_id=...
    NSDictionary * params = @{k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_id,
                              k_BLOCKID : @(block_id).stringValue};
    
    self = [super initWith:link Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    if (json) {
        return  (BaseJSON *)[[out_block_chat alloc] initWithJSON:json];
    }
    return (BaseJSON *) [[out_block_chat alloc] init];
}

@end
