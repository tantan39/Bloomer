//
//  out_block_chat.h
//  Bloomer
//
//  Created by Le Chau Tu on 4/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BaseJSON.h"

@interface out_block_chat : NSObject<BaseJSON>
@property (nonatomic, strong) NSString* screenname;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString* avatar;
@end
