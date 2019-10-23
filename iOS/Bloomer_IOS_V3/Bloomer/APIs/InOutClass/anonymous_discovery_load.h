//
//  anonymous_discovery_load.h
//  Bloomer
//
//  Created by Le Chau Tu on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UsingAPIs.h"
//#import "out_discovery_fetches.h"

@interface anonymous_discovery_load : UsingAPIs <connectToServer>

//@property (nonatomic, strong) void(^completion)(out_discovery_fetches *data);
@property (strong, nonatomic) void(^failure)(ASIHTTPRequest* request);

- (id)initWithGender:(NSInteger)gender city:(NSString *)city is_refresh:(BOOL)is_refresh uid:(NSInteger)uid;

@end
