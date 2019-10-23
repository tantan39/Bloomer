//
//  SplashScreenViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Profile_Me.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"
#import "TabBarViewController.h"
#import "image_photo.h"
#import "API_FetchAPost.h"
#import "out_post_fetch_apost.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "SelectScreenViewController.h"
//#import "auth_expired_using.h"
#import "auth_refresh_token.h"
#import "out_auth_refresh_token.h"
#import "API_Auth_RefreshToken.h"
#import "API_Auth_Logout.h"
#import "API_GetVersion.h"

@interface SplashScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet FLAnimatedImageView *introScreen;

@property (strong, nonatomic) NSMutableArray *faceData;

- (void)refreshToken;
- (void)logout;

//- (void)getDataLogout:(out_auth_logout *)data;

@end
