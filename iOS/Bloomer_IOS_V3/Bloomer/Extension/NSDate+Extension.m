//
//  NSDate+Extension.m
//  Bloomer
//
//  Created by Steven on 10/18/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString*)toFullDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz";
    dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    return [dateFormatter stringFromDate:self];
}

- (NSString*)toISO8601Format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormatter.timeZone = [[NSTimeZone alloc] initWithName:@"UTC"];
    return [dateFormatter stringFromDate:self];
}

- (NSString*)toBirthdayFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    return [dateFormatter stringFromDate:self];
}

- (NSString*)toOnlyMonthYearFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"MM/yyyy";
    return [dateFormatter stringFromDate:self];
}

- (NSString*)toDayMonthYearFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    return [dateFormatter stringFromDate:self];
}

- (NSString*)toOnlyHourFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = @"HH";
    return [dateFormatter stringFromDate:self];
}

+ (NSArray*)exportAllDaysInMonth:(NSDate*)date
{
    NSString *monthYearFormat = [date toOnlyMonthYearFormat];
    NSArray *array = [monthYearFormat componentsSeparatedByString:@"/"];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = [(NSString*)array[1] integerValue];
    dateComponents.month = [(NSString*)array[0] integerValue];
    
    NSCalendar *calendar = NSCalendar.currentCalendar;
    NSDate *finalDate = [calendar dateFromComponents:dateComponents];
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:finalDate];
    NSMutableArray *dayList = [[NSMutableArray alloc] init];
    
    for (NSInteger day = range.location; day <= range.length; day++)
    {
        if (day < 10)
        {
            [dayList addObject:[NSString stringWithFormat:@"0%ld/%@", day, monthYearFormat]];
        }
        else
        {
            [dayList addObject:[NSString stringWithFormat:@"%ld/%@", day, monthYearFormat]];
        }
    }
    
    return dayList;
}

+ (NSDate*)getPreviousDay:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = -1;
    
    return [calendar dateByAddingComponents:dateComponents toDate:date options:0];
}

+ (NSString *)currentTimeString{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];
    return currentTime;
}
@end

