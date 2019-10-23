//
//  PopUpMarketing.h
//  Bloomer
//
//  Created by Steven on 4/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PopUpMarketing : NSObject

@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *bodyLink;
@property (strong, nonatomic) NSString *bodyText;

- (id)initWithID:(NSInteger)ID startDate:(NSString*)startDate endDate:(NSString*)endDate type:(NSInteger)type bodyLink:(NSString*)bodyLink bodyText:(NSString*)bodyText;

@end
