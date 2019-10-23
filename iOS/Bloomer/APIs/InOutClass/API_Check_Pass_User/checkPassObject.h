//
//  checkPassObject.h
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 3/6/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface checkPassObject : NSObject<BaseJSON>

@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSInteger app_id;
@property (assign, nonatomic) NSInteger country_id;

- (id)initWithMobile:(NSString *)mobile
             app_id:(NSInteger)app_id
          country_id:(NSInteger)country;

@end
