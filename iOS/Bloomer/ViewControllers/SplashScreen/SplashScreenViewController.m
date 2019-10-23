//
//  SplashScreenViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/23/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "UpdatePopupViewController.h"
#import "WeakLinkObj.h"
#import "AnonymousTabBarController.h"

@interface SplashScreenViewController () {
    UserDefaultManager *userDefaultManager;
    image_photo *imagePhotoAPI;
    UINavigationController *navigationController;
    NSTimer *dismissSplashTimer;
}
@end

@implementation SplashScreenViewController

- (void)dealloc {
    NSLog(@"SplashScreenViewController deallocated");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [dismissSplashTimer invalidate];
    dismissSplashTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self invokeGetVersionAPI];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(invokeGetVersionAPI)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
}

- (void)invokeGetVersionAPI {
    API_GetVersion *request = [[API_GetVersion alloc] init];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (data.status) {
            out_getversion *model = (out_getversion *)json;
            NSString *lastestVersion = model.version;
            NSString *currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            
            NSArray *lastestVerArray = [lastestVersion componentsSeparatedByString:@"."];
            NSArray *currentVerArray = [currentVersion componentsSeparatedByString:@"."];
            
            for(int i = 0; i < 2; i++) {
                int lastestNum = [[lastestVerArray objectAtIndex:i] intValue];
                int currentNum = [[currentVerArray objectAtIndex:i] intValue];
                if(currentNum < lastestNum) {
                    [self checkVersion_OnFailed];
                    return;
                }
            }
            [self checkVersion_OnPassed];
        }
    } ErrorHandlure:^(NSError * error) {
        NSLog(@"API_GetVersion request failed");
    }];
}

- (void)checkVersion_OnPassed {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.restrictRotation = YES;
    
    userDefaultManager = [appDelegate getUserManager];
    imagePhotoAPI = [[image_photo alloc] init];
    
    if (dismissSplashTimer != nil) {
        [dismissSplashTimer invalidate];
        dismissSplashTimer = nil;
    }
    dismissSplashTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:[WeakLinkObj weakObjectWithRealTarget:self]
                                                        selector:@selector(dismissSplashscreen)
                                                        userInfo:nil repeats:false];
}

- (void)checkVersion_OnFailed {
    UpdatePopupViewController *view = [[UpdatePopupViewController alloc] initWithNibName:@"UpdatePopupViewController" bundle:nil];
    [self presentViewController:view animated:NO completion:nil];
}

- (void)dismissSplashscreen
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    NSString *accessToken = [userDefaultManager getAccessToken];
    
    if (accessToken == nil) {
        //        if([userDefaultManager getDeepLinkTag].length) {
        //            [userDefaultManager setAnonymous:true];
        //
        //            if (![userDefaultManager didPostDailyLocalNotification])
        //            {
        //                [LocalNotificationHelper postDailyLocalNotification];
        //                [userDefaultManager setDidPostDailyLocalNotification:true];
        //            }
        //
        //            AnonymousTabBarController *tabBarController = [[AnonymousTabBarController alloc] initWithNibName:@"AnonymousTabBarController" bundle:nil];
        //            [self.navigationController pushViewController:tabBarController animated:true];
        //        } else {
        SelectScreenViewController *view = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
        [self.navigationController pushViewController:view animated:YES];
        //        }
    } else {
        [self loadProfileInfo];
    }
}

- (void)loadProfileInfo
{
    
    API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON * json, RestfulResponse *objStatus) {
        out_profile_fetch * object = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            if(object.verified == 0)
            {
                [userDefaultManager saveUserProfileData:object];
                //                [userDefaultManager saveChatSetting:_numFlower];
                TabBarViewController *tabbarView = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [tabbarView setSelectedIndex:3];
                [self.navigationController pushViewController:tabbarView animated:TRUE];
                
                navigationController = (UINavigationController *)tabbarView.selectedViewController;
                
                if ([userDefaultManager isNotification])
                {
                    [userDefaultManager saveIsNotification:FALSE];
                    NSDictionary *userInfo = [userDefaultManager getUserInfo];
                    if (userInfo) {
                        [AppHelper handlePushNotificationWithUserInfo:userInfo];
                    }
                }
            } else {
                [self navigateToSelectSreenVC];
            }
        }
        else
        {
            [self navigateToSelectSreenVC];
        }
        
    } ErrorHandlure:^(NSError * error) {
        
    }];
}

- (void) navigateToSelectSreenVC{
    SelectScreenViewController *mainViewController = [[SelectScreenViewController alloc] initWithNibName:@"SelectScreenViewController" bundle:nil];
    [self.navigationController pushViewController:mainViewController animated:TRUE];
}


- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController == self);
}

@end
