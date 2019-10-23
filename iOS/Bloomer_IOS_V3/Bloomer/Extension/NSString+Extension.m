//
//  NSString (Extension).m
//  Bloomer
//
//  Created by Ahri on 11/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)removeDuplicateNewLines {
    NSMutableArray *linesArray = [NSMutableArray new];
    NSMutableArray *contentsArray = [NSMutableArray new];
    [self enumerateLinesUsingBlock: ^(NSString * line, BOOL * stop) {
        [linesArray addObject:line];
    }];
    NSString *newStr = @"";
    for (int i = 0; i < linesArray.count; i++) {
        NSString *line = linesArray[i];
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        line = [line stringByTrimmingCharactersInSet:set];
        if (line.length != 0) {
            [contentsArray addObject:line];
        }
    }
    NSUInteger n = 0;
    if(contentsArray.count <= 10)
    {
        n = contentsArray.count;
    }
    else
    {
        n = 10;
    }
    
    for (int i = 0; i < n; i++) {
        NSString *line = contentsArray[i];
        newStr = [newStr stringByAppendingString:line];
        if (linesArray.count > 1 && i != linesArray.count - 1) {
            newStr = [newStr stringByAppendingString:@"\n"];
        }
    }
    
    return newStr;
}

- (NSString *)generatePhotoURL{
    if ([UIScreen isRetinaHD]) {
        NSString * extension = [self pathExtension];
        NSInteger index = [self length] - [extension length] - 1;
        NSString * url = [self substringToIndex:index];
        NSString * last = [[url stringByAppendingString:@"_plus."] stringByAppendingString:extension];
        return last;
    }
    return self;
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)convertStringFromJSON:(NSDictionary *)json{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)convertDictionaryFromString:(NSString *)stringJSON{
    NSData *data = [stringJSON dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

+ (NSString *)stringFromDate:(NSDate *)date WithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT+7"]];
    
    return [formatter stringFromDate:date];
}

- (NSDate*)convertToDateWithFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:self];
}

@end
