//
//  BannerMarketing.h
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extension.h"

@interface BannerMarketing : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *bodyLink;
@property (strong, nonatomic) NSString *bodyText;
@property (strong, nonatomic) NSString *footLink;
@property (strong, nonatomic) NSString *headLink;

- (id)initWithID:(NSInteger)ID startDate:(NSString*)startDate endDate:(NSString*)endDate type:(NSInteger)type bodyLink:(NSString*)bodyLink bodyText:(NSString*)bodyText footLink:(NSString*)footLink headLink:(NSString*)headLink;

@end
