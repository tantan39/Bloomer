//
//  JSON_PostUserFetches.m
//  Bloomer
//
//  Created by Ahri on 8/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "JSON_RacesNameFetch.h"

@implementation JSON_RacesNameFetch

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSDictionary *output = json[k_RACENAMES];
        
        //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        //    [dateFormat setDateFormat:@"yyyy-MM-dd kk:mm:ss"];
        //    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        //    [dateFormat setTimeZone:gmt];
        
        _name = output[k_NAME];
        _isJoin = [output[k_IS_JOINED] integerValue];
        _start = [output[k_START] integerValue];
        _startDate = output[k_DATE_START];//[dateFormat dateFromString: output[:k_DATE_START]];
        _endDate = output[k_DATE_END];//[dateFormat dateFromString:output[:k_DATE_END]] ;
        _end = [output[k_END] integerValue];
        _rules = output[k_RULES];
        _category = [output[k_CATEGORY] integerValue];
        _isActive = [output[k_IS_ACTIVE] integerValue];
        _key = output[k_KEY];
        _raceInfo = output[k_RACE_INFO];
        _joinInfo = output[k_JOIN_INFO];
        _leaveInfo = output[k_LEAVE_INFO];
        _closedURL = output[k_CLOSED_URL];
        _locationID = [output[k_LOCATION_ID] integerValue];
        _isClosed = [output[k_IS_CLOSED] boolValue];
        _isComingSoon = [output[@"is_comingsoon"] boolValue];
        
        _childsList = [[NSMutableArray alloc] init];
        NSArray *childsList = output[k_CHILDS];
        for (int i = 0; i < childsList.count; i++) {
            NSDictionary *temp = childsList[i];
            
            childs *newChild = [[childs alloc] initWithName:temp[k_NAME] key:temp[k_KEY]];
            [_childsList addObject:newChild];
        }
    }
    return self;
}

@end
