//
//  Maketing_popup_using.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 4/14/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_PopupMarketing.h"

@implementation API_PopupMarketing

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token
{
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token};
    self = [self initWith:[APIDefine getPopupMarketingLink] Params:params];
    return self;
}

-(BaseJSON *)handleJSON:(NSDictionary *)json {
    JSON_PopUpMarketing *model;
    if(json) {
        model = [[JSON_PopUpMarketing alloc] initWithJSON:json];
    }
    return (BaseJSON*)model;
}

@end
