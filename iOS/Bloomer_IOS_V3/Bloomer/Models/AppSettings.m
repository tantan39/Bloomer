//
//  AppSettings.m
//  Bloomer
//
//  Created by Tan Tan on 11/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "AppSettings.h"

@implementation AppSettings

+ (instancetype)shareInstance{
    static AppSettings * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppSettings alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSDictionary * appSeting = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppSettings"];
        self.rootAPIURL = [appSeting objectForKey:@"RootAPIURL"];
        self.rootWebURL = [appSeting objectForKey:@"RootWebURL"];
        self.rootChatURL = [appSeting objectForKey:@"RootChatURL"];
        self.rootPhotoURL = [appSeting objectForKey:@"RootPhotoURL"];
        self.hostSocket = [appSeting objectForKey:@"HostSocket"];
        self.googleServiceFileName = [appSeting objectForKey:@"GoogleServiceFile"];
    }
    return self;
}

@end
