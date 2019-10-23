//
//  PopUpMarketing.m
//  Bloomer
//
//  Created by Steven on 4/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PopUpMarketing.h"

@implementation PopUpMarketing

- (id)initWithID:(NSInteger)ID startDate:(NSString*)startDate endDate:(NSString*)endDate type:(NSInteger)type bodyLink:(NSString*)bodyLink bodyText:(NSString*)bodyText
{
    self.ID = ID;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    self.startDate = [dateFormat dateFromString:startDate];
    self.endDate = [dateFormat dateFromString:endDate];
    self.type = type;
    self.bodyLink = bodyLink;
    self.bodyText = bodyText;
    
    return self;
}

@end
