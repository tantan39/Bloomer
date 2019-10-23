//
//  API_Delete_Conversation.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "deleteConversionData.h"
#import "out_account_forget_verifycode.h"
#import "BaseJSON.h"
#import "APIDefine.h"

@interface API_Delete_Conversation : BloomerRestful

- (instancetype)initWithParams:(deleteConversionData *) data;

@end
