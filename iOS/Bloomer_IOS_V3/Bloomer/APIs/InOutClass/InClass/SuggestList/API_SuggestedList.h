//
//  API_SuggestedList.h
//  Bloomer
//
//  Created by Steven on 12/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BloomerRestful.h"
#import "Json_SuggestedList.h"


@interface API_SuggestedList : BloomerRestful

@property (weak, nonatomic) NSString* raceKey;

- (instancetype)initWithAccessToken:(NSString *)access_token
             device_token:(NSString *)device_token;

@end
