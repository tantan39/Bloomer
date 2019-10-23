//
//  API_NotiMarketing
//  Bloomer
//
//  Created by Tu Le on 8/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_NotiMarketing.h"

@implementation API_NotiMarketing

-(id)initWithAccessToken:(NSString *)access_token device_token:(NSString*)device_token
{
    NSDictionary *params = @{k_ACCESS_TOKEN: access_token,
                             k_DEVICE_TOKEN: device_token};
    
    self = [super initWith:[APIDefine getNotiMarketing] Params:params];
    
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
