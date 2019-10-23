//
//  API_PopUpTopWinners.h
//  Bloomer
//
//  Created by Steven on 1/2/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "JSON_TopWinners.h"

@interface API_PopUpTopWinners : BloomerRestful

- (id)initWithAccessToken:(NSString*)accessToken deviceToken:(NSString*)deviceToken;

@end
