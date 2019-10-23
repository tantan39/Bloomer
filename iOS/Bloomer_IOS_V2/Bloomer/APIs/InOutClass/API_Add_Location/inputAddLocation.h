//
//  inputAddLocation.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/9/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface inputAddLocation : NSObject<BaseJSON>

@property (assign, nonatomic) NSInteger location;
@property (strong, nonatomic) NSString* access_token;
@property (strong, nonatomic) NSString* device_id;

- (id)initWithLocation:(NSInteger)location
          access_token:(NSString*)access_token
             device_id:(NSString*)device_id;
@end
