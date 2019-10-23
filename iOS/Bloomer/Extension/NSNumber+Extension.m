//
//  NSNumber+Extension.m
//  Bloomer
//
//  Created by Le Chau Tu on 12/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

-(NSString*)formatWithLocale:(NSLocale*)locale {
    NSNumberFormatter* nf = [NSNumberFormatter new];
    [nf setMaximumFractionDigits:2];
    [nf setLocale:locale];
    [nf setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString* string = [nf stringFromNumber:self];
    return string;
}

-(NSString*)formatWithCurrency:(NSString*)currency {
    NSString *string;
    if ([currency isEqualToString:@"VND"] || [currency isEqualToString:@"EUR"]) {
        string = [self formatWithLocale:[NSLocale localeWithLocaleIdentifier:@"vi-VN"]];
    } else {
        string = [self formatWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    }
    return string;
}

@end
