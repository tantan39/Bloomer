//
//  API_Message_Send.h
//  Bloomer
//
//  Created by Tran Thai Tan on 8/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "message_send.h"
#import "out_message_send.h"
#import "BaseJSON.h"

@interface API_Message_Send : BloomerRestful

@property (strong, nonatomic) NSString* responseID;

- (instancetype)initWithParams:(message_send*) params ResponseID:(NSString *) responseID Header:(NSString *) header;

@end
