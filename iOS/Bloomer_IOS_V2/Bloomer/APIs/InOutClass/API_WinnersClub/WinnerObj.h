//
//  WinnersObj.h
//  Bloomer
//
//  Created by Ahri on 10/13/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinnerObj : NSObject

@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *username;
@property (assign, nonatomic) NSInteger flower;
@property (assign, nonatomic) NSString *gsb_medal;
@property (strong, nonatomic) NSString *video;
@property (assign, nonatomic) BOOL is_icon;

@end
