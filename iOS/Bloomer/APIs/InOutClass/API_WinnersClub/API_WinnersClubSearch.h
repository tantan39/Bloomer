//
//  API_WinnersClubSearch.h
//  Bloomer
//
//  Created by Ahri on 10/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BloomerRestful.h"
#import "APIDefine.h"
#import "JSON_WinnersClub.h"

@interface API_WinnersClubSearch : BloomerRestful

- (id)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token
                      gsb:(NSInteger)gsb gender:(NSInteger)gender page:(NSInteger)page
                     size:(NSInteger)size term:(NSString *)term;

@end
