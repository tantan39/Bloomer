//
//  auth_register.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseJSON.h"

@interface auth_register : NSObject<BaseJSON>

//@property (assign, nonatomic) NSInteger gender;
@property (strong, nonatomic) NSString *photo_id;

@property (strong, nonatomic) NSString *access_token;
@property (strong, nonatomic) NSString *device_token;
@property (strong, nonatomic) NSString *birthday;
@property (assign, nonatomic) NSInteger location_id;


- (instancetype)initWithPhotoID:(NSString*)photoID Access_Token:(NSString*)access_token Device_Token:(NSString*)device_token BirthDay:(NSString *) birthDay LocationID:(NSInteger) locationID;

@end
