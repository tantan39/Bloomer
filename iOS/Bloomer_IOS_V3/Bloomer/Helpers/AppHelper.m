//
//  AppHelper.m
//  Bloomer
//
//  Created by Steven on 1/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AppHelper.h"
#import "API_PopUpMarketing.h"
#import "UserDefaultManager.h"
#import "HotNewsPopUpView.h"
#import "AnonymousLoginPopUpView.h"
#import "UIColor+Extension.h"
#import <FBSDKAppEvents.h>
#import "MatchingFlowerPopUpView.h"
#import "AppDelegate.h"
#import "InviteCodeViewController.h"
#import "RedeemInviteCodeViewController.h"
#import "MySettingViewController.h"
#import "AnonymousTabBarController.h"
#import "AnonymousRaceListViewController.h"
#import "AnonymousMyBloomerViewController.h"
#import "AnonymousDiscoveryViewController.h"
#import "AnonymousUserProfileViewController.h"

@implementation AppHelper

+ (NSString*)getLocalizedString:(NSString*)string
{
    return NSLocalizedString(string, @"");
}

+ (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation objectSize:(CGSize)objectSize
{
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = objectSize.width;
    draggableLocation.objectHeight = objectSize.height;
    
    // set the bounding margins for this location
    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = MARGIN_VERTICAL;
    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;
    
    // set up highlight-on-drag-over behavior
    draggableLocation.highlightColor = [UIColor greenColor].CGColor;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;
    
    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;
    
    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
    
    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

+ (void)configureDraggableObject:(SEDraggable *)draggable draggableLocation:(SEDraggableLocation*)draggableLocation
{
    draggable.homeLocation = draggableLocation;
    [draggableLocation addDraggableObject:draggable animated:NO];
}

+ (void)configureDraggableLocation:(SEDraggableLocation *)draggableLocation objectSize:(CGSize)objectSize isCircle:(BOOL)isCircle hightlight:(BOOL)highlight highlightColor:(UIColor*)highlightColor
{
    // set the width and height of the objects to be contained in this SEDraggableLocation (for spacing/arrangement purposes)
    draggableLocation.objectWidth = objectSize.width;
    draggableLocation.objectHeight = objectSize.height;
    
    // set the bounding margins for this location
    draggableLocation.marginLeft = MARGIN_HORIZONTAL;
    draggableLocation.marginRight = MARGIN_HORIZONTAL;
    draggableLocation.marginTop = MARGIN_VERTICAL;
    draggableLocation.marginBottom = MARGIN_VERTICAL;
    
    // set the margins that should be preserved between auto-arranged objects in this location
    draggableLocation.marginBetweenX = MARGIN_HORIZONTAL;
    draggableLocation.marginBetweenY = MARGIN_VERTICAL;
    
    // set up highlight-on-drag-over behavior
    if (highlight)
    {
        draggableLocation.highlightColor = highlightColor.CGColor;
    }
    else
    {
        draggableLocation.highlightColor = [UIColor clearColor].CGColor;
    }
    
    if (isCircle)
    {
        draggableLocation.layer.cornerRadius = draggableLocation.frame.size.width / 2;
    }
    
    draggableLocation.clipsToBounds = true;
    draggableLocation.highlightOpacity = 0.4f;
    draggableLocation.shouldHighlightOnDragOver = YES;
    
    // you may want to toggle this on/off when certain events occur in your app
    draggableLocation.shouldAcceptDroppedObjects = NO;
    
    // set up auto-arranging behavior
    draggableLocation.shouldKeepObjectsArranged = YES;
    draggableLocation.fillHorizontallyFirst = YES; // NO makes it fill rows first
    draggableLocation.allowRows = YES;
    draggableLocation.allowColumns = YES;
    draggableLocation.shouldAnimateObjectAdjustments = YES; // if this is set to NO, objects will simply appear instantaneously at their new positions
    draggableLocation.animationDuration = 0.5f;
    draggableLocation.animationDelay = 0.0f;
    draggableLocation.animationOptions = UIViewAnimationOptionLayoutSubviews ; // UIViewAnimationOptionBeginFromCurrentState;
    
    draggableLocation.shouldAcceptObjectsSnappingBack = YES;
}

+ (AwesomeMenu *)createCircularMenuWithFrame:(CGRect)frame startPoint:(CGPoint)startPoint delegate:(id)delegate
{
    UIImage *backgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1"];
    UIImage *highlightedBackgroundImage1 = [UIImage imageNamed:@"GivingFlowers_1"];
    UIImage *backgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10"];
    UIImage *highlightedBackgroundImage10 = [UIImage imageNamed:@"GivingFlowers_10"];
    UIImage *backgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100"];
    UIImage *highlightedBackgroundImage100 = [UIImage imageNamed:@"GivingFlowers_100"];
    AwesomeMenuItem *flowerButton1 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage1
                                      highlightedImage:highlightedBackgroundImage1
                                      text:@(FIRST_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton2 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage10
                                      highlightedImage:highlightedBackgroundImage10
                                      text:@(SECOND_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton3 = [[AwesomeMenuItem alloc]
                                      initWithImage:backgroundImage100
                                      highlightedImage:highlightedBackgroundImage100
                                      text:@(THIRD_FLOWER_BUTTON_VALUE).stringValue];
    AwesomeMenuItem *flowerButton4 = [[AwesomeMenuItem alloc]
                                      initWithImage:[UIImage imageNamed:@"GivingFlowers_..."]
                                      highlightedImage:[UIImage imageNamed:@"GivingFlowers_..."]
                                      text:@""];
    NSArray *menus = [NSArray arrayWithObjects:flowerButton1, flowerButton2, flowerButton3, flowerButton4, nil];
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                                       highlightedImage:[UIImage imageNamed:@"GivingFlower_Store"]
                                                                   text:@""];
    
    AwesomeMenu *resultMenu = [[AwesomeMenu alloc] initWithFrame:frame startItem:startItem optionMenus:menus isCell:FALSE];
    resultMenu.startPoint = startPoint;
    resultMenu.delegate = delegate;
    resultMenu.menuWholeAngle = 2.5f;
    resultMenu.farRadius = 60.0f;
    resultMenu.endRadius = 50.0f;
    resultMenu.nearRadius = 40.0f;
    resultMenu.animationDuration = 0.7f;
    resultMenu.rotateAngle = 5.04f;
    [resultMenu setExpanding:YES];
    
    return resultMenu;
}

+ (void)createThankYouView:(ThankYou*)thankYouView point:(CGPoint)point frame:(CGRect)frame
{
    [thankYouView removeFromSuperview];
    
    if (thankYouView)
    {
        [thankYouView repositionToPoint:point];
    }
    else
    {
        thankYouView = [[ThankYou alloc] initWithStyle:ThankYouStyleForCollectionViewCell atPoint:point frame:frame];
    }
}

+ (void)setTitleViewForNavigationBar:(UINavigationItem*)navigationItem title:(NSString*)title
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:NAVIGATION_TITLE_FONT_SIZE];
    titleView.textColor = [UIColor colorFromHexString:@"#444444"];
    titleView.text = title;
    navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

+ (void)setTitleViewForNavigationBar:(UINavigationItem*)navigationItem title:(NSString*)title color:(UIColor*)color
{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:NAVIGATION_TITLE_FONT_SIZE];
    titleView.textColor = color;
    titleView.text = title;
    navigationItem.titleView = titleView;
    [titleView sizeToFit];
}

+ (void)showMessageBox:(NSString*)title message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Alert.TryAgain",nil)
                                          otherButtonTitles:nil];
    [alert show];
}

+ (void)showMessageUnderNavBar:(UIViewController *)viewcontroller message:(NSString *)message timer:(BOOL)timer{
    [TTMessageView showMessageUnderNavBar:viewcontroller Message:message Timer:timer];
}

+ (void)setupConstraintsForHorizontalView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView width:(CGFloat)width spacing:(CGFloat)spacing
{
    NSLayoutConstraint *leftMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    }
    else
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1 constant:spacing];
    }
    
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
    
    [parentView addConstraints:@[topMargin, leftMargin, bottomMargin]];
    [view addConstraint:widthConstraint];
}

+ (void)setupFullStretchConstraintsForView:(UIView*)view parentView:(UIView*)parentView
{
    NSLayoutConstraint* leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint* rightMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint* topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint* bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [parentView addConstraints:@[topMargin, leftMargin, rightMargin, bottomMargin]];
}

+ (UIImage*)cropToBounds:(UIImage*)image rect:(CGRect)rect
{
    //you need to update scaling factor value if deice is not retina display
    //    UIGraphicsBeginImageContextWithOptions(rect.size)
    //    UIGraphicsBeginImageContext(rect.size);
    //
    //    //stick to methods on UIImage so that orientation etc. are automatically
    //    // dealt with for us
    //    [image drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    //
    //    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //
    //    return result;
    //    rect = CGRectMake(rect.origin.x * image.scale, rect.origin.y * image.scale, rect.size.width * image.scale, rect.size.height * image.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

+ (void)showPopUpMarketing
{
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    
    if ([userDefaultManager getUserProfileData] != nil)
    {
        API_PopUpMarketing *api = [[API_PopUpMarketing alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            JSON_PopUpMarketing *popUps = (JSON_PopUpMarketing*)jsonObject;
            for (PopUpMarketing *popUp in popUps.popUps)
            {
                if (popUp.type == 3 || popUp.type == 4)
                {
                    HotNewsPopUpView *popUpView = [HotNewsPopUpView createInView:[[UIApplication sharedApplication] delegate].window contentLink:popUp.bodyLink];
                    [popUpView showWithAnimated:true];
                }
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }
}

+ (void)showAnonymousLoginPopUpView
{
    AnonymousLoginPopUpView *popUpView = [AnonymousLoginPopUpView createInView:UIApplication.sharedApplication.keyWindow];
    [popUpView showWithAnimated:true];
}

+ (void)changeNavigationBarToRed:(UINavigationController*)navigationController
{
//    navigationController.navigationBar.translucent = false;
//    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    navigationController.navigationBar.barTintColor = [UIColor colorFromHexString:@"#B22225"];
//    navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (void)changeNavigationBarToWhite:(UINavigationController*)navigationController
{
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar.backItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:nil] ];
    navigationController.navigationBar.translucent = FALSE;
    [navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    navigationController.navigationBar.tintColor = [UIColor colorFromHexString:@"#202021"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}


+ (void)changeNavigationBarToClearColor:(UINavigationController*)navigationController
{
    [navigationController setNavigationBarHidden:NO];
    [navigationController.navigationBar.backItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:self action:nil] ];
    navigationController.navigationBar.translucent = TRUE;
    [navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationController.navigationBar.barTintColor = [UIColor clearColor];
    navigationController.navigationBar.tintColor = [UIColor colorFromHexString:@"#202021"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

+ (void)hideShadowImageNavigationBar:(UINavigationController *)navigationController{
    navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

+ (void)FBLogCompletedRegistration:(NSString*)registrationMethod {
    NSDictionary *params = @{FBSDKAppEventParameterNameRegistrationMethod: registrationMethod};
    [FBSDKAppEvents logEvent:FBSDKAppEventNameCompletedRegistration
                  parameters:params];
}

+ (void)showMatchingFlowerPopUp:(NSInteger)flowers
{
    [MatchingFlowerPopUpView createInView:UIApplication.sharedApplication.keyWindow flowers:flowers];
}

+ (void)setButtonWithUnderlineTitle:(UIButton *)button textColor:(UIColor *)color fontSize:(CGFloat)fontSize {
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: button.titleLabel.textColor,
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:button.titleLabel.text
                                                                           attributes:linkAttributes];
    [button.titleLabel setAttributedText:attributedString];
}

+ (void)handleDeeplink {
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString *tag = [userDefaultManager getDeepLinkTag];
    if ([tag isEqualToString:@"race"]) {
        [delegate.tabBarView setSelectedIndex:0];
        NSInteger gender = [[[userDefaultManager getDeeplinkParams] objectForKey:@"gender"] integerValue];
        NSString *key = [[userDefaultManager getDeeplinkParams] objectForKey:@"key"];
        
        if(![[userDefaultManager getDeeplinkParams] objectForKey:@"gender"]) {
            gender = [userDefaultManager getUserProfileData].gender;
        }
        
        if (key == nil)
        {
            UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
            if([userDefaultManager getUserProfileData]) {
                if(![currentNavController.topViewController isKindOfClass:[RaceListsViewController class]]) {
                    [currentNavController popToRootViewControllerAnimated:YES];
                }
                RaceListsViewController *vc = (RaceListsViewController*)currentNavController.topViewController;
                if(gender == 0) {
                    [vc touchButtonFemale:nil];
                } else {
                    [vc touchButtonMale:nil];
                }
            }
        }
        else
        {
            delegate.tabBarView.selectedIndex = 0;
            UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
            
            RacesViewController *raceViewController = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
            raceViewController.key = key;
            raceViewController.gender = gender;
            [currentNavController pushViewController:raceViewController animated:YES];
        }
    } else if([tag isEqualToString:@"mybloomer"]) {
        [delegate.tabBarView setSelectedIndex:1];
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if([userDefaultManager getUserProfileData]) {
            if(![currentNavController.topViewController isKindOfClass:[FriendsUpdateViewController class]]) {
                [currentNavController popToRootViewControllerAnimated:YES];
            }
        }
    } else if([tag isEqualToString:@"discovery"]) {
        [delegate.tabBarView setSelectedIndex:3];
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if([userDefaultManager getUserProfileData]) {
            if(![currentNavController.topViewController isKindOfClass:[DiscoveryViewController class]]) {
                [currentNavController popToRootViewControllerAnimated:YES];
            }}
    } else if([tag isEqualToString:@"me"] && [userDefaultManager getUserProfileData]) {
            [delegate.tabBarView setSelectedIndex:4];
            UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
            if(![currentNavController.topViewController isKindOfClass:[MyProfileViewController class]]) {
                [currentNavController popToRootViewControllerAnimated:YES];
            }
    } else if([tag isEqualToString:@"shop"] && [userDefaultManager getUserProfileData]) {
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if(![currentNavController.topViewController isKindOfClass:[FlowerGardenViewController class]]) {
            FlowerGardenViewController *vc = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
            [vc setHidesBottomBarWhenPushed:YES];
            [currentNavController pushViewController:vc animated:YES];
        }
    } else if([tag isEqualToString:@"invite"] && [userDefaultManager getUserProfileData]) {
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if(![currentNavController.topViewController isKindOfClass:[InviteCodeViewController class]]) {
            InviteCodeViewController *vc = [[InviteCodeViewController alloc] initWithNibName:@"InviteCodeViewController" bundle:nil];
            [vc setHidesBottomBarWhenPushed:YES];
            [currentNavController pushViewController:vc animated:YES];
        }
    } else if([tag isEqualToString:@"redeem"] && [userDefaultManager getUserProfileData]) {
        NSString *code = [[userDefaultManager getDeeplinkParams] objectForKey:@"code"];
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if(![currentNavController.topViewController isKindOfClass:[RedeemInviteCodeViewController class]]) {
            RedeemInviteCodeViewController *vc = [[RedeemInviteCodeViewController alloc] initWithNibName:@"RedeemInviteCodeViewController" bundle:nil];
            vc.code = code;
            [vc setHidesBottomBarWhenPushed:YES];
            [currentNavController pushViewController:vc animated:YES];
        } else {
            RedeemInviteCodeViewController *vc = (RedeemInviteCodeViewController*)currentNavController.topViewController;
            [vc.textFieldCode setText:code];
        }
    } else if([tag isEqualToString:@"profile"]) {
        NSInteger uid = [[[userDefaultManager getDeeplinkParams] objectForKey:@"uid"] integerValue];
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if([userDefaultManager getUserProfileData]) {
            if(![currentNavController.topViewController isKindOfClass:[UserProfileViewController class]]) {
                UserProfileViewController *vc = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                vc.uid = uid;
                [currentNavController pushViewController:vc animated:YES];
            } else {
                UserProfileViewController *vc = (UserProfileViewController*)currentNavController.topViewController;
                if(vc.uid != uid) {
                    UserProfileViewController *newVc = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
                    newVc.uid = uid;
                    [currentNavController pushViewController:newVc animated:YES];
                }
            }
        }
    } else if ([tag isEqualToString:@"setting"] && [userDefaultManager getUserProfileData]) {
        UINavigationController *currentNavController = (UINavigationController*)delegate.tabBarView.selectedViewController;
        if(![currentNavController.topViewController isKindOfClass:[MySettingViewController class]]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MySetting" bundle:nil];
            MySettingViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MySetting"];
            [vc setHidesBottomBarWhenPushed:YES];
            [currentNavController pushViewController:vc animated:YES];
        }
    }
    
    [userDefaultManager setDeepLinkTagWithString:@""];
}

+ (void)handlePushNotificationWithUserInfo:(NSDictionary *)userInfo{
    NSString* type = [userInfo valueForKey:k_TYPE];
    NSString* name = [userInfo valueForKey:k_SCREEN_NAME];
    NSString* photo_id = @"";
    NSInteger uid = 0;
    NSString* post_id = @"";
    NSInteger irace = 0;
    NSString* senderScreenName = @"";
    NSString* avatar = @"";
    NSInteger senderUID = 0;
    NSString* roomID = @"";
    
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
    

    UINavigationController *navController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    
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
                chatViewController.roomID = roomID;
                chatViewController.screen_name = senderScreenName;
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
                [navigationController pushViewController:chatListViewController animated:false];
                [navigationController pushViewController:chatViewController animated:true];
                
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
                
                if ([type isEqualToString:PushNotificationType.kReceivedFlowerAvatarRace])
                {
                    flowerGiverViewController.notificationKey = post_id;
                }else if ([type isEqualToString:PushNotificationType.kReceivedFlowerAvatarProfile]){
                     flowerGiverViewController.notificationKey = @"profile";
                }else
                {
                    flowerGiverViewController.notificationKey = @"";
                    flowerGiverViewController.post_id = post_id;
                    flowerGiverViewController.userID = uid;
                }
                
                flowerGiverViewController.hidesBottomBarWhenPushed = true;
                
                [navigationController pushViewController:flowerGiverViewController animated:true];
            }
            
        }
    }
}

+ (void)handleMessageIncoming:(message *)message{
    UINavigationController *navController = (UINavigationController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    
    for (UIViewController* viewController in navController.visibleViewController.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[TabBarViewController class]])
        {
            TabBarViewController *tabBarViewController = (TabBarViewController*)viewController;
            UINavigationController *profileNavigationController = (UINavigationController*)tabBarViewController.viewControllers[kTabBarProfileIndex];
            
            NSString * content = [NSString stringWithFormat:NSLocalizedString(@"Chat.incomingmessage%@",nil), message.name];
            if ([profileNavigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]])
            {
                ChatViewController *chatViewController = (ChatViewController*)profileNavigationController.viewControllers.lastObject;
                if (chatViewController.uid != message.sender_id)
                {
                    [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:content avatar:message.avatar type:PushNotificationType.kReceivedChatMessage uid:message.sender_id screenName:message.name RoomID:message.room_id];
                    
                }
                return;
            }else{
                UINavigationController* navigationController = (UINavigationController*)tabBarViewController.selectedViewController;
                if ([navigationController.viewControllers.lastObject isKindOfClass:[ChatViewController class]]){
                    ChatViewController *chatViewController = (ChatViewController*)navigationController.viewControllers.lastObject;
                    if (chatViewController.uid != message.sender_id)
                    {
                        [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:content avatar:message.avatar type:PushNotificationType.kReceivedChatMessage uid:message.sender_id screenName:message.name RoomID:message.room_id];
                        
                    }
                    return;
                }

            }
            
            [PushNotificationPopUpView createInView:UIApplication.sharedApplication.keyWindow message:[AppHelper getLocalizedString:@"PushNotification.details"] name:content avatar:message.avatar type:PushNotificationType.kReceivedChatMessage uid:message.sender_id screenName:message.name RoomID:message.room_id];
            
            return;
        }
    }
}

+ (NSMutableAttributedString*)makeBoldText:(NSString*)text inString:(NSString*)string font:(UIFont*)font color:(UIColor*)color
{
    NSRange range = [string rangeOfString:text];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString beginEditing];
    [attrString addAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font} range:range];
    [attrString endEditing];
    
    return attrString;
}

+ (void)configFirebase{
    NSString * fileName = [[AppSettings shareInstance] googleServiceFileName];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    FIROptions * option = [[FIROptions alloc] initWithContentsOfFile:filePath];
    
    [FIRApp configureWithOptions:option];
}

+ (NSString*) getScreenNameView:(NSString*) nameXib {

    if ([AppHelper isIP5AndIP4]) {
        return [nameXib stringByAppendingString: @"_IP5"];
    }
    return nameXib;
}

+ (BOOL) isIP5AndIP4 {
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        return TRUE;
    }
    return FALSE;
}

+ (CGFloat) getHightTextView: (NSString*) text font: (UIFont*) font with: (CGFloat) width {
    UITextView * tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    tv.font = font;
    tv.text = text;
    [tv sizeToFit];
    return tv.frame.size.height;
}
@end
