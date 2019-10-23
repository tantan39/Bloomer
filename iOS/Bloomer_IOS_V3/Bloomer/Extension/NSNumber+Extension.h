//
//  NSNumber+Extension.h
//  Bloomer
//
//  Created by Le Chau Tu on 12/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)

-(NSString*)formatWithLocale:(NSLocale*)locale;
-(NSString*)formatWithCurrency:(NSString*)currency;
- (NSString * ) formatThounsandStyle;
@end
