//
//  AppDelegate.h
//  Xinh
//
//  Created by Truong Thuan Tai on 11/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//
@class TabBarViewController;
#import <UIKit/UIKit.h>
#import "SplashScreenViewController.h"
#import "ResetPasswordVerifyCodeViewController.h"
#import "API_Auth_Expired.h"
#import "auth_refresh_token.h"
#import "out_auth_refresh_token.h"
#import "API_Message_Disconnect.h"
#import "NotificationViewController.h"
#import "ChatViewController.h"
#import "image_photo.h"
#import "UIImageView+AFNetworking.h"
//#import "post_fetch_apost_using.h"
#import "API_Content_Post_Fetches.h"
#import "post_detail.h"
#import "out_post_fetch_apost.h"
#import "face.h"
#import "TabBarView.h"
#import "MKNumberBadgeView.h"
#import "Spinner.h"
#import "Support.h"
//expire token
#import "API_Auth_RefreshToken.h"
#import "FlowerGardenViewController.h"
#import "API_Notification_Pull.h"

#import "TabBarViewController.h"
#import "IAPHelper.h"
#import "BloomerManager.h"
#import "LocationManager.h"
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIDynamicAnimatorDelegate,FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (strong, nonatomic) API_Notification_Pull *pullNotificationAPI;
//@property (strong, nonatomic) NSTimer *pullAPITimer;
@property (strong, nonatomic) NSMutableArray *faceData;
@property (strong, nonatomic) TabBarView *tabbar;
@property (strong, nonatomic) MKNumberBadgeView *badgeNumber;
@property (strong, nonatomic) MKNumberBadgeView *chatBadgeNumber;
@property (strong, nonatomic) Spinner *spinner;
@property (strong, nonatomic) TabBarViewController *tabBarView;

@property (strong, nonatomic) NSMutableArray *pendingRequests;
@property (assign, nonatomic) BOOL isTokenRefreshing;
@property BOOL isOpen;

@property () BOOL restrictRotation;
@property () BOOL restrictLandscape;

-(UserDefaultManager*) getUserManager;
- (void)updateShowingNofitication;
+(void) setSelectedIndexTabbar:(NSInteger)index;
-(void)refreshToken;
@end

