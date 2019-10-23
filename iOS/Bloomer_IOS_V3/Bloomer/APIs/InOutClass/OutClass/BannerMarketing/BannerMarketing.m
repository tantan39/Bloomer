//
//  BannerMarketing.m
//  Bloomer
//
//  Created by Steven on 7/16/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "BannerMarketing.h"

@implementation BannerMarketing : NSObject

- (id)initWithID:(NSInteger)ID startDate:(NSString*)startDate endDate:(NSString*)endDate type:(NSInteger)type bodyLink:(NSString*)bodyLink bodyText:(NSString*)bodyText footLink:(NSString*)footLink headLink:(NSString*)headLink
{
    self.ID = ID;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    self.startDate = [dateFormat dateFromString:startDate];
    self.endDate = [dateFormat dateFromString:endDate];
    self.type = type;
    self.bodyLink = [bodyLink generatePhotoURL];
    self.bodyText = bodyText;
    self.footLink = footLink;
    self.headLink = headLink;
    
    return self;
}

@end
