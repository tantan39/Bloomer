//
//  NSString (Extension).h
//  Bloomer
//
//  Created by Ahri on 11/23/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScreen+Extension.h"
#import <CommonCrypto/CommonDigest.h>
@interface NSString (Extension)

- (NSString *)removeDuplicateNewLines;

- (NSString *) generatePhotoURL;

+ (NSString *)md5:(NSString *)input;
+ (NSString *) convertStringFromJSON:(NSDictionary *) json;

+ (NSDictionary *) convertDictionaryFromString:(NSString *) stringJSON;

+ (NSString *) stringFromDate:(NSDate *) date WithFormat:(NSString *) format;
- (NSDate*)convertToDateWithFormat:(NSString*)format;
@end
