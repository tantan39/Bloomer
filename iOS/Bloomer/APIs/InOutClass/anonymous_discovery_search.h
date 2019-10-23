//
//  anonymous_discovery_search.h
//  Bloomer
//
//  Created by Le Chau Tu on 5/4/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UsingAPIs.h"
#import "out_discovery_search.h"

@interface anonymous_discovery_search : UsingAPIs <connectToServer>

@property (nonatomic, strong) void(^completion)(out_discovery_search *data);
@property (strong, nonatomic) void(^failure)(ASIHTTPRequest* request);

-(id)initWithTerm:(NSString *)term
                    size:(NSInteger) size
                    page:(NSInteger) page;

@end
