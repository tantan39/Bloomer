//
//  TabBarViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/4/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "UserDefaultManager.h"
#import "DiscoveryViewController.h"
#import "RaceListsViewController.h"
#import "FriendsUpdateViewController.h"

@class MyProfileViewController;

@interface TabBarViewController : UITabBarController
@property (strong, nonatomic) TabBarView *tabbar;

-(MyProfileViewController*)getMyProfileVC;
- (void) enableMeNotification:(BOOL)isEnable;
@end
