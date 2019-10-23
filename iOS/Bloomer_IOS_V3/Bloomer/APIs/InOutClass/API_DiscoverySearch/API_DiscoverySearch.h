//
//  API_DiscoverySearch.h
//  Bloomer
//
//  Created by Ahri on 8/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "JSON_DiscoverySearch.h"

@interface API_DiscoverySearch : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token
                     term:(NSString *)term
                     size:(NSInteger)size
                     page:(NSInteger)page;

- (id)initWithTerm:(NSString *)term
              size:(NSInteger)size
              page:(NSInteger)page;


@end
