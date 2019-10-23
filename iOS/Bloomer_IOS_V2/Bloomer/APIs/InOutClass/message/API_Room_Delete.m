//
//  API_Room_Delete.m
//  Bloomer
//
//  Created by Tran Thai Tan on 8/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "API_Room_Delete.h"

@implementation API_Room_Delete

- (instancetype)initWithAccessToken:(NSString *)access_token device_token:(NSString *)device_token roomID:(NSString *)roomID{
    
    NSDictionary * params = @{
                              k_ACCESS_TOKEN : access_token,
                              k_DEVICE_TOKEN : device_token,
                              k_ROOM_ID : roomID
                              };

    self = [super initWith:[APIDefine room_delete] Params:params];
    return self;
}

- (BaseJSON *)handleJSON:(NSDictionary *)json{
    
    if (json) {
        out_account_forget_verifycode * model = [[out_account_forget_verifycode alloc] initWithJSON:json];
        return (BaseJSON *) model;
    }
    
    return (BaseJSON *) [[out_account_forget_verifycode alloc] init];
}

@end
