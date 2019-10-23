//
//  API_CheckMobileLinkFacebook.h
//  Bloomer
//
//  Created by Steven on 3/11/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "JSON_CheckMobileLinkFacebook.h"

@interface API_CheckMobileLinkFacebook : BloomerRestful

- (instancetype)initWithMobile:(NSString*)mobile countryID:(NSInteger)countryID deviceToken:(NSString*)deviceToken;

@end
