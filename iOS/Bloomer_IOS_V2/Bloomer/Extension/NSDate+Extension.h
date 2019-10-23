//
//  NSDate+Extension.h
//  Bloomer
//
//  Created by Steven on 10/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

- (NSString*)toFullDateFormat;
- (NSString*)toISO8601Format;
- (NSString*)toBirthdayFormat;
- (NSString*)toOnlyMonthYearFormat;
- (NSString*)toDayMonthYearFormat;
- (NSString*)toOnlyHourFormat;
+ (NSArray*)exportAllDaysInMonth:(NSDate*)date;
+ (NSDate*)getPreviousDay:(NSDate*)date;
+ (NSString *) currentTimeString;

@end
