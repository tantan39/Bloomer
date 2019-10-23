//
//  AppDelegate.m
//  Xinh
//
//  Created by Truong Thuan Tai on 11/19/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "TabBarView.h"
#import "OpenUDID.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <GoogleConversionTracking/ACTReporter.h>
#import "BrowserViewController.h"
#import "AppHelper.h"
#import "ConfirmationViewController.h"
#import "LocalNotificationHelper.h"
#import "NavigationViewController.h"
#import "API_GetCountries.h"
#import "PushNotificationPopUpView.h"
#import "VerifyUpdatePhoneNumberViewController.h"

@interface AppDelegate ()
{
    UserDefaultManager *userDefaultManager;
    image_photo* imagePhotoAPI;
    BOOL isFirstLoad;
}
@end

@implementation AppDelegate
@synthesize isOpen;

-(UserDefaultManager*) getUserManager
{
    return userDefaultManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [AppHelper configFirebase];

    [FIRMessaging messaging].delegate = self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[IAPHelper sharedInstance]];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    imagePhotoAPI = [[image_photo alloc] init];
    self.pendingRequests =[[NSMutableArray alloc] init];
    isFirstLoad = TRUE;
    isOpen = FALSE;
    
    [userDefaultManager saveIsPushNotificationToOtherRace:FALSE];
    [userDefaultManager setAnonymous:false];

    // This line for setting back button image.
    UIImage *backButtonImage = [UIImage imageNamed:@"Icon_Back_White"];
    [UINavigationBar appearance].backIndicatorImage = backButtonImage;
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = backButtonImage;
    
    NSString *openUDID = [OpenUDID value];
    NSLog(@"device id: %@", openUDID);
    [userDefaultManager saveDeviceToken:openUDID];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [LocalNotificationHelper setup];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    SplashScreenViewController *splash = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:splash];

    [navigation setNavigationBarHidden:TRUE];

    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    if (launchOptions != nil)
    {
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (notification)
        {
            NSLog(@"app recieved notification from remote%@",notification);
            [self application:application didReceiveRemoteNotification:(NSDictionary*)notification];
        }
        else
        {
            NSLog(@"app did not recieve notification");
        }
    }
    
    int cacheSizeMemory = 10*1024*1024; // 4MB
    int cacheSizeDisk = 512*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    //init SPINNER
    _spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) Color:[UIColor redColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_spinner];
    
    // Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    // Google conversion tracking
    [ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"872263736"];
    [ACTConversionReporter reportWithConversionID:@"872263736" label:@"v_9aCPuK8mwQuOD2nwM" value:@"0.00" isRepeatable:NO];
    
    // Fabric
    [Fabric with:@[[Crashlytics class]]];
    
    //FB SDK handle incoming url from outside of app
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if(error) {
            NSLog(@"%@", error);
        } else if(url) {
            [application openURL:url];
        }
    }];
    
    API_GetCountries *api = [[API_GetCountries alloc] init];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            JSON_CountriesList *json = (JSON_CountriesList*)jsonObject;
            [[BloomerManager shareInstance] setListCountry:json.countriesList];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
    
    [[LocationManager sharedInstance] startUpdatingLocation];
    
    [[SDImageCache sharedImageCache] setMaxCacheAge:60 * 30]; //Set time cache image in 30 min
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url host] isEqualToString:@"verify"])
    {
        NSDictionary *dictionary = [self parseQueryString:[url query]];
        NSString *verifyCode = dictionary[@"code"];
        
        if (![verifyCode isEqualToString:@""])
        {
            UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
            
            if ([navigationController.visibleViewController isKindOfClass:[ConfirmationViewController class]])
            {
                ConfirmationViewController *viewController = (ConfirmationViewController*)navigationController.visibleViewController;
                [viewController setVerifyCodeNumber:verifyCode];
            }
            
            if ([navigationController.visibleViewController isKindOfClass:[ResetPasswordVerifyCodeViewController class]])
            {
                ResetPasswordVerifyCodeViewController *viewController = (ResetPasswordVerifyCodeViewController*)navigationController.visibleViewController;
                [viewController setVerifyCodeNumber:verifyCode];
            }
            
            if ([navigationController.visibleViewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)navigationController.visibleViewController;
                UINavigationController *selectedNavigationController = (UINavigationController*)[tabBarViewController selectedViewController];
                
                if ([selectedNavigationController.visibleViewController isKindOfClass:[ConfirmationViewController class]])
                {
                    ConfirmationViewController *viewController = (ConfirmationViewController*)selectedNavigationController.visibleViewController;
                    [viewController setVerifyCodeNumber:verifyCode];
                }
            }
            
            if ([navigationController.visibleViewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)navigationController.visibleViewController;
                UINavigationController *selectedNavigationController = (UINavigationController*)[tabBarViewController selectedViewController];
                
                if ([selectedNavigationController.visibleViewController isKindOfClass:[VerifyUpdatePhoneNumberViewController class]])
                {
                    VerifyUpdatePhoneNumberViewController *viewController = (VerifyUpdatePhoneNumberViewController*)selectedNavigationController.visibleViewController;
                    [viewController setVerifyCodeNumber:verifyCode];
                }
            }
        }
    } else {
        [userDefaultManager setDeepLinkTagWithString:[url host]];
        [userDefaultManager setDeeplinkParams:[self parseQueryString:[url query]]];
        
        if (self.tabBarView) {
            [AppHelper handleDeeplink];
        } /*else if ([((UINavigationController*)self.window.rootViewController).topViewController isKindOfClass:[SelectScreenViewController class]]) {
            [NotificationHelper postNotificationForopeningAnonymousTab];
        }*/
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    
    return true;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([[url host] isEqualToString:@"verify"])
    {
        NSDictionary *dictionary = [self parseQueryString:[url query]];
        NSString *verifyCode = dictionary[@"code"];

        if (![verifyCode isEqualToString:@""])
        {
            if ([verifyCode length] > 4) {
                NSRange range = NSMakeRange(0, 4);
                verifyCode = [verifyCode substringWithRange:range];
            }
            UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;

            if ([navigationController.visibleViewController isKindOfClass:[ConfirmationViewController class]])
            {
                ConfirmationViewController *viewController = (ConfirmationViewController*)navigationController.visibleViewController;
                [viewController setVerifyCodeNumber:verifyCode];
            }

            if ([navigationController.visibleViewController isKindOfClass:[ResetPasswordVerifyCodeViewController class]])
            {
                ResetPasswordVerifyCodeViewController *viewController = (ResetPasswordVerifyCodeViewController*)navigationController.visibleViewController;
                [viewController setVerifyCodeNumber:verifyCode];
            }

            if ([navigationController.visibleViewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)navigationController.visibleViewController;
                UINavigationController *selectedNavigationController = (UINavigationController*)[tabBarViewController selectedViewController];

                if ([selectedNavigationController.visibleViewController isKindOfClass:[ConfirmationViewController class]])
                {
                    ConfirmationViewController *viewController = (ConfirmationViewController*)selectedNavigationController.visibleViewController;
                    [viewController setVerifyCodeNumber:verifyCode];
                }
            }
            
            if ([navigationController.visibleViewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)navigationController.visibleViewController;
                UINavigationController *selectedNavigationController = (UINavigationController*)[tabBarViewController selectedViewController];
                
                if ([selectedNavigationController.visibleViewController isKindOfClass:[VerifyUpdatePhoneNumberViewController class]])
                {
                    VerifyUpdatePhoneNumberViewController *viewController = (VerifyUpdatePhoneNumberViewController*)selectedNavigationController.visibleViewController;
                    [viewController setVerifyCodeNumber:verifyCode];
                }
            }
        }
    } else {
        [userDefaultManager setDeepLinkTagWithString:[url host]];
        [userDefaultManager setDeeplinkParams:[self parseQueryString:[url query]]];

        if (self.tabBarView) {
            [AppHelper handleDeeplink];
        } /*else if ([((UINavigationController*)self.window.rootViewController).topViewController isKindOfClass:[SelectScreenViewController class]]) {
            [NotificationHelper postNotificationForopeningAnonymousTab];
        }*/
    }

    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];

    return handled;
}


- (UIViewController*)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Send token to server
    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeUnknown];
    NSString * token = [[FIRMessaging messaging] FCMToken];
    [userDefaultManager saveNotificationToken:token];
}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken{
    NSLog(@"FCM registration token: %@", fcmToken);
    [userDefaultManager saveNotificationToken:fcmToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSString* alertMessage = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
    NSString* type = [userInfo valueForKey:k_TYPE];
    NSString* name = [userInfo valueForKey:k_SCREEN_NAME];
    NSString* photo_id = @"";
    NSInteger uid = 0;
    NSString* post_id = @"";
    NSInteger irace = 0;
    NSString* senderScreenName = @"";
    NSString* avatar = @"";
    NSInteger senderUID = 0;
    NSString * roomID = @"";
    
    NSLog(@"Userinfo: %@", userInfo);
    
    if ([userInfo valueForKey:k_PHOTO_ID] != [NSNull null])
    {
        photo_id = [userInfo valueForKey:k_PHOTO_ID];
    }
    
    if ([userInfo valueForKey:k_UID] != [NSNull null])
    {
        uid = [[userInfo valueForKey:k_UID] integerValue];
    }
    
    if ([userInfo valueForKey:k_SENDER_ID] != [NSNull null])
    {
        senderUID = [[userInfo valueForKey:k_SENDER_ID] integerValue];
    }
    
    if ([userInfo valueForKey:k_POST_ID] != [NSNull null])
    {
        post_id = [userInfo valueForKey:k_POST_ID];
    }
    
    if ([userInfo valueForKey:k_iRACE] != [NSNull null])
    {
        irace = [[userInfo valueForKey:k_iRACE] integerValue];
    }
    
    if ([userInfo valueForKey:@"sender_screen_name"] != [NSNull null])
    {
        senderScreenName = [userInfo valueForKey:@"sender_screen_name"];
    }
    
    if ([userInfo valueForKey:k_AVATAR] != [NSNull null])
    {
        avatar = [userInfo valueForKey:k_AVATAR];
    }
    
    if ([userInfo valueForKey:k_ROOM_ID_NOTI] != [NSNull null])
    {
        roomID = [userInfo valueForKey:k_ROOM_ID_NOTI];
    }
    
    if ([application applicationState] == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground)
    {
        if (!isOpen)
        {
            [userDefaultManager saveIsNotification:TRUE];
        }
        else
        {
            [userDefaultManager saveIsNotification:FALSE];
        }
        
        [userDefaultManager saveUserInfo:userInfo];
        
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        
        for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[TabBarViewController class]])
            {
                
                TabBarViewController *tabBarViewController = (TabBarViewController*)viewController;
                
                if ([type isEqualToString:PushNotificationType.kReceivedChatMessage])
                {
                    tabBarViewController.selectedIndex = kTabBarProfileIndex;
                    UINavigationController* navigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
                    
                    ChatListViewController *chatListViewController = [[ChatListViewController alloc] initWithNibName:@"ChatListViewController" bundle:nil];
                    chatListViewController.hidesBottomBarWhenPushed = true;
                    
                    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
                    chatViewController.uid = uid;
                    chatViewController.screen_name = senderScreenName;
                    chatViewController.roomID = roomID;
                    chatViewController.isChat = true;
                    if (![avatar isEqualToString:@""])
                    {
                        NSURL *url = [[NSURL alloc] initWithString:avatar];
                        UIImageView * imgAvatar = [[UIImageView alloc] init];
                        [imgAvatar setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Icon_Other_Users_Avatar"]];
                        chatViewController.receiverAvatar = imgAvatar;
                    }
                    chatViewController.hidesBottomBarWhenPushed = TRUE;
                    
                    [navigationController popToRootViewControllerAnimated:false];
                    [[SocketManager shareInstance] setOnAuthenSuccess:^{
                        [navigationController pushViewController:chatListViewController animated:false];
                        [navigationController pushViewController:chatViewController animated:true];
                    }];
                    
                    
                    return;
                }
                
                if ([type isEqualToString:PushNotificationType.kReceivedComment])
                {
                    tabBarViewController.selectedIndex = kTabBarProfileIndex;
                    UINavigationController* navigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
                    
                    FullPictureViewController *commentViewController = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
                    
                    gallery* gallerypost = [[gallery alloc]init];
                    gallerypost.post_id = post_id;
                    
                    commentViewController.post_id = post_id;
                    commentViewController.isScrollingEnabled = FALSE;
                    commentViewController.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
                    commentViewController.currentIndex = 0;
                    
                    commentViewController.parentView = nil;
                    
                    [navigationController popToRootViewControllerAnimated:false];
                    [navigationController pushViewController:commentViewController animated:true];
                }
                
                if ([type isEqualToString:PushNotificationType.kReceivedFlowerAvatarRace]
                    || [type isEqualToString:PushNotificationType.kReceivedFlowerAvatarProfile]
                    || [type isEqualToString:PushNotificationType.kReceivedFlowerPhoto])
                {
                    UINavigationController* navigationController = (UINavigationController*)tabBarViewController.selectedViewController;
                    
                    FlowerGiverViewController *flowerGiverViewController = [[FlowerGiverViewController alloc] init];
                    
                    if ([type isEqualToString:PushNotificationType.kReceivedFlowerAvatarRace]){
                        flowerGiverViewController.notificationKey = post_id;
                        
                    }else if ([type isEqualToString:PushNotificationType.kReceivedFlowerAvatarProfile]){
                        
                        flowerGiverViewController.notificationKey = @"profile";
                    }else{
                        
                        flowerGiverViewController.notificationKey = @"";
                        flowerGiverViewController.post_id = post_id;
                        flowerGiverViewController.userID = uid;
                    }
                    
                    flowerGiverViewController.hidesBottomBarWhenPushed = true;
                    
                    [navigationController pushViewController:flowerGiverViewController animated:true];
                }
                
                break;
                
               
            }
        }
    }
    else //App Activated
    {
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        
        for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController *tabBarViewController = (TabBarViewController*)viewController;
                UINavigationController *profileNavigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
                
                if ([type isEqual: PushNotificationType.kReceivedChatMessage])
                {
                    if ([profileNavigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]])
                    {
                        ChatViewController *chatViewController = (ChatViewController*)profileNavigationController.viewControllers.lastObject;
                        if (chatViewController.uid != uid)
                        {
                            [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:alertMessage avatar:avatar type:type uid:senderUID screenName:senderScreenName RoomID:nil];
                        }
                    }
                    else
                    {
                        [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:alertMessage avatar:avatar type:type uid:senderUID screenName:senderScreenName RoomID:nil];
                    }
                    return;
                }
                
                if ([type isEqual:PushNotificationType.kReceivedComment]
                    || [type isEqualToString: PushNotificationType.kReceivedFlowerPhoto]
                    || [type isEqualToString: PushNotificationType.kReceivedFlowerAvatarRace]
                    || [type isEqualToString: PushNotificationType.kReceivedFlowerAvatarProfile])
                {
                    [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:alertMessage avatar:avatar type:type uid:uid screenName:name postID:post_id];
                    return;
                }
                
                break;
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    NSString *identifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
    NSArray *splitArray = [identifier componentsSeparatedByString:@"#$#"];
    
    if ([splitArray[0] isEqual: kSpotlightSearchLeaderboard])
    {
        NSString *raceKey = splitArray[1];
        NSInteger gender = [splitArray[2] isEqualToString:@"Male"] ? 1 : 0;
        
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;

        for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[TabBarViewController class]])
            {
                NSURL *deepLinkURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"bloomer://race?key=%@&gender=%@", raceKey, @(gender).stringValue]];
                [[UIApplication sharedApplication] openURL:deepLinkURL];
            }
        }
    }
    
    if ([splitArray[0]  isEqual: kSpotlightSearchUser])
    {
        NSInteger uid = [splitArray[1] integerValue];
        NSURL *deepLinkURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"bloomer://profile?uid=%@", @(uid).stringValue]];
        [[UIApplication sharedApplication] openURL:deepLinkURL];
    }
    
    return true;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background. UpdateAvatarSignUpVC
    isOpen = TRUE;
    if ([userDefaultManager getAccessToken] != nil) {
        [[SocketManager shareInstance] establishConnection];
    }
    
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    
    if (![navigationController.viewControllers.lastObject isKindOfClass:[SelectScreenViewController class]] && ![navigationController.viewControllers.lastObject isKindOfClass:[CreatePasswordViewController class]] && ![navigationController.viewControllers.lastObject isKindOfClass:[UpdateInfoViewController class]] && ![navigationController.viewControllers.lastObject isKindOfClass:[ConfirmationViewController class]] && [userDefaultManager getAccessToken] != nil)
    {
        API_Auth_Expired *expireAPI = [[API_Auth_Expired alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
        [expireAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                JSON_Auth_Expired *json = (JSON_Auth_Expired*)jsonObject;
                if(json) {
                    if(json.is_expired) {
                        [self refreshToken];
                    }
                }
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

-(NSURL*) updateAccessTokenURL:(NSURL*)url{
    NSString* sURL = url.absoluteString;
    
    if (![sURL isEqualToString:@""]) {
        
        NSArray *foo = [sURL componentsSeparatedByString: @"?"];
        NSString *rightSide = [foo objectAtIndex:1];
        NSArray *foo2 = [rightSide componentsSeparatedByString:@"&"];
        
        NSString *rightParam = @"";
        
        NSArray *foo3 = [[foo2 objectAtIndex: 0] componentsSeparatedByString:@"="];
            
        sURL = [sURL stringByReplacingOccurrencesOfString:[foo3 objectAtIndex: 1] withString:[userDefaultManager getAccessToken]];
   
        NSLog(@"%@", sURL);
    }
    return [NSURL URLWithString:sURL];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL returnValue = NO;
    
    NSString *urlString = [url absoluteString];
    if([urlString hasPrefix:@"bloomer://"])
    {
        returnValue = YES;
    }
    
    return returnValue;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    UINavigationController *rootNavigationController = (UINavigationController*)self.window.rootViewController;
    UINavigationController *secondNavigationController = rootNavigationController.visibleViewController.navigationController;
    
    if ([secondNavigationController.viewControllers.lastObject isKindOfClass:[TabBarViewController class]])
    {
        TabBarViewController *tabBarViewController = (TabBarViewController*)secondNavigationController.viewControllers.lastObject;
        UINavigationController *navigationController = (UINavigationController*)tabBarViewController.selectedViewController;
        
        if ([navigationController.visibleViewController isKindOfClass:[BrowserViewController class]])
        {
            return UIInterfaceOrientationMaskAll;
        }
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [userDefaultManager removeIsNotification];
    [[SocketManager shareInstance] closeConnection];
    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    isOpen = TRUE;
    [FBSDKAppEvents activateApp];
    
    [self forceRequestPullNotification];
    
    // reset awesome - when has interrupt action during dragging.Bug #2760
    [self.tabbar snapbackFlowerIconToTabbar];
    
    //    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[SocketManager shareInstance] closeConnection];
}


-(void)updateShowingNofitication
{
    BOOL isShow = FALSE;
    if ([[self getUserManager] getChatNotificationNumber] + [[self getUserManager] getNotificationNumber] > 0 || ![[userDefaultManager getMedalKey] isEqualToString:@""]) {
        isShow = TRUE;
    }
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[TabBarViewController class]])
        {
            TabBarViewController* view = (TabBarViewController*)viewController;
            [view enableMeNotification:isShow];
        }
    }
}

+(void) setSelectedIndexTabbar:(NSInteger)index
{
    // index value : 0-RaceList ; 1-FriendsUpdate; 2- ; 3-Discovery ; 4-Me
    UINavigationController *navController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[TabBarViewController class]])
        {
            TabBarViewController* view = (TabBarViewController*)viewController;
            [view setSelectedIndex:index];
        }
    }
}

//REFRESH TOKEN
- (void)refreshToken
{
    if(self.isTokenRefreshing)
        return;
    if(userDefaultManager == nil){
        userDefaultManager = [self getUserManager];
    }
    NSString *secretClient = [userDefaultManager generateSecretClient];
    NSString *encryptedSecretClient = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:secretClient iv:[userDefaultManager getAppSecret]];
    
    NSString *encryptedRefreshToken = [userDefaultManager encryptDESByKey:[userDefaultManager getAppKey] data:[userDefaultManager getRefresh_Token] iv:secretClient];
    
    auth_refresh_token *params = [[auth_refresh_token alloc] initWithDevice_Token:[userDefaultManager getDeviceToken] access_token:[userDefaultManager getAccessToken] refresh_token:encryptedRefreshToken secret_client:encryptedSecretClient];
    self.isTokenRefreshing =TRUE;
    if (params) {
        API_Auth_RefreshToken * api = [[API_Auth_RefreshToken alloc] initWithParams:params];
        [api postRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_auth_refresh_token * data = (out_auth_refresh_token *)json;
            if (objStatus.status)
            {
                [userDefaultManager saveAccessToken:data.access_token];
                
                //retry all requests pending during refresh token
                for (BloomerRestful* pendingRequest in self.pendingRequests) {

                    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:pendingRequest._params];
                    [params setObject:[userDefaultManager getAccessToken] forKey:k_ACCESS_TOKEN];
                    [pendingRequest set_params:params];
                    [pendingRequest request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                        
                    } ErrorHandlure:^(NSError *error) {
                       
                    }];
                    
                }
                [self.pendingRequests removeAllObjects];
                self.isTokenRefreshing = FALSE;
            }
        } ErrorHandlure:^(NSError * error) {
            
        }];
    }
}

// MARK: - Other functions

- (void)forceRequestPullNotification
{
    if (![[userDefaultManager getAccessToken] isEqualToString:@""] && [userDefaultManager getAccessToken])
    {
        UINavigationController *navigationController = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        for (UIViewController* viewController in navigationController.visibleViewController.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[TabBarViewController class]])
            {
                TabBarViewController* tabBarViewController = (TabBarViewController*)viewController;
                UINavigationController* raceListNavigationViewController = tabBarViewController.viewControllers[kTabBarRaceIndex];
                RaceListsViewController* raceListViewController = raceListNavigationViewController.viewControllers.firstObject;
                [raceListViewController initPullNotification];
                break;
            }
        }
    }
}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByRemovingPercentEncoding];
        NSString *val = [elements[1] stringByRemovingPercentEncoding];
        
        [dict setObject:val forKey:key];
    }
    
    return dict;
}

@end
