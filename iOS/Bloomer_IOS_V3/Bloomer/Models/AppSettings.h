//
//  AppSettings.h
//  Bloomer
//
//  Created by Tan Tan on 11/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppSettings : NSObject
+ (instancetype) shareInstance;

@property (strong,nonatomic) NSString * rootAPIURL;
@property (strong,nonatomic) NSString * rootWebURL;
@property (strong,nonatomic) NSString * rootChatURL;
@property (strong,nonatomic) NSString * rootPhotoURL;
@property (strong,nonatomic) NSString * hostSocket;
@property (strong,nonatomic) NSString * googleServiceFileName;

@end

NS_ASSUME_NONNULL_END
