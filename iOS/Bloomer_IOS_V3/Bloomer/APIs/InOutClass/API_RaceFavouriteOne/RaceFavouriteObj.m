//
//  race_favourite.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/16/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "RaceFavouriteObj.h"

@implementation RaceFavouriteObj

- (void)extractData:(NSDictionary *)data {
    _uid = [data[k_UID] integerValue];
    _name = data[k_NAME];
    _avatar = data[k_AVATAR];
    _photo_id = data[k_PHOTO_ID];
    _num_flower = [data[k_NUM_FLOWER] longLongValue];
    
    NSDictionary *rank = data[k_RANK];
    _race_name = data[k_RACE];
    _status_of_rank = [rank[k_STATUS_RANK] integerValue];
    _rank = [rank[k_RANK] integerValue];
    _color_code = rank[k_COLOR_CODE];
    _codes = [rank[k_CODE] integerValue];
}

@end
