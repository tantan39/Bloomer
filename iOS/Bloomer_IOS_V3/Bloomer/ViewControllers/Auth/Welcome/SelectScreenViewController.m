//
//  WelcomeViewController.m
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 10/16/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "SelectScreenViewController.h"
#import "AppHelper.h"
#import "LoginViewController.h"
@interface SelectScreenViewController () {
    NSTimer *timer;
    BOOL isOutScreen;
    BOOL isFirstLoad;
    UserDefaultManager * userDefaultManager;
    Spinner * spinner;
    FBSDKLoginManager * loginManager;
    NSInteger country_id;
}
@end

@implementation SelectScreenViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:[AppHelper getScreenNameView: nibNameOrNil] bundle:nibBundleOrNil];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpPageViewController];
    [self.pageControl setCurrentPage:0];
    [self setUpButton];
    isOutScreen = FALSE;
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    isFirstLoad = true;
    [[BloomerManager shareInstance] setCountryID:1];
    country_id = [BloomerManager shareInstance].countryID;
    userDefaultManager = [[UserDefaultManager alloc] init];
    loginManager = [[FBSDKLoginManager alloc] init];
    spinner = [(AppDelegate *)[[UIApplication sharedApplication] delegate] spinner];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isOutScreen = FALSE;
    [self.navigationController setNavigationBarHidden:TRUE];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setUpTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    isOutScreen = TRUE;
    [self invalidateTimer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setUpPageViewController {
    
    self.arrPageTitles = @[[AppHelper getLocalizedString:@"selecSceen.titleWelcome1Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome2Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome3Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome4Label"],[AppHelper getLocalizedString:@"selecSceen.titleWelcome5Label"]];
    self.arrPageImages =@[@"welcome1",@"welcome2",@"welcome3",@"welcome4",@"welcome5"];
    self.pageIndex = 0;
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    [self.carousel setPagingEnabled:TRUE];
    [self.carousel reloadData];}

- (void) setUpButton {
    [self.buttonSignUp setTitle: [AppHelper getLocalizedString:@"Sign Up"] forState:UIControlStateNormal];
    self.buttonSignUp.layer.cornerRadius = 4;
    [self.buttonSignIn setTitle: [AppHelper getLocalizedString:@"Sign In"] forState:UIControlStateNormal];
    self.buttonSignIn.layer.cornerRadius = 4;
    self.buttonSignIn.layer.borderColor = [[UIColor rgb:178 green:34 blue:37] CGColor];
    self.buttonSignIn.layer.borderWidth = 2.0f;
    [self.buttonLoginBF setTitle:[AppHelper getLocalizedString: @"login.signFBLabel"] forState:UIControlStateNormal];
    
    [self.buttonLoginBF.layer setCornerRadius:4];
}

- (void) setUpTimer {
    [self invalidateTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changePage) userInfo:nil repeats:FALSE];
}

- (void) invalidateTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) changePage {
    if (isOutScreen) {
        return;
    }
    if (self.pageIndex < 4) {
        self.pageIndex ++;
    } else {
        self.pageIndex = 0;
    }
    [self.carousel scrollToItemAtIndex:self.pageIndex animated:TRUE];
    [self.pageControl setCurrentPage:self.pageIndex];
}

- (PageContentViewController *) viewControllerAtIndex:(NSUInteger)index {
    
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"PageContentViewController"] bundle:nil];
    pageContentViewController.imgFile = self.arrPageImages[index];
    pageContentViewController.txtTitle = self.arrPageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
    
}



- (IBAction)signUpTapper:(id)sender {
    SignUpVC * signUpVC = [[SignUpVC alloc] init];
    [self.navigationController pushViewController:signUpVC animated:true];
}

- (IBAction)signInTapper:(id)sender {
    LoginViewController *view = [[LoginViewController alloc] initWithNibName:[AppHelper getScreenNameView:@"LoginViewController"] bundle:nil];
    
    [self.navigationController pushViewController:view animated:TRUE];
}
- (IBAction)signInFBTapper:(id)sender {
    if([FBSDKAccessToken currentAccessToken]) {
        [loginManager logOut];
    }
    [loginManager logInWithReadPermissions:@[@"public_profile",@"email",@"user_link"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [AppHelper showMessageBox:nil message:error.localizedDescription];
        } else if (result.isCancelled) {
            NSLog(@"%@", @"User cancelled.");
        } else {
            [spinner startAnimating];
            
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,link,gender,name,email,picture.height(800).width(800)",}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSLog(@"%@", result);
                    Auth_FBRegisterParams * object = [[Auth_FBRegisterParams alloc] initWithJSON:result];
                    [object setDevice_id:[userDefaultManager getDeviceToken]];
                    [[BloomerManager shareInstance] setAuth_FBRegister:object];
                    if (object) {
                        [self requestCheckFBExitsWithFBToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
                    } else {
                        [spinner stopAnimating];
                    }
                } else {
                    [spinner stopAnimating];
                }
            }];
        }
    }];
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.arrPageImages count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (view == nil) {
        PageContentViewController * vc = [self viewControllerAtIndex:index];
        view = vc.view;
        view.frame = self.carousel.bounds;
    }
    
    for (UIView* child in [view subviews]) {
        if (child.tag == 111) {
            ((UILabel*)child).text = [self.arrPageTitles objectAtIndex:index];
        } else if (child.tag == 222) {
            ((UIImageView*)child).image = [UIImage imageNamed:[self.arrPageImages objectAtIndex:index]];
        }
    }
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
   if (view == nil) {
       PageContentViewController * vc = [self viewControllerAtIndex:index];
       view = vc.view;
       view.frame = self.carousel.bounds;
   }
    
    for (UIView* child in [view subviews]) {
        if (child.tag == 111) {
            ((UILabel*)child).text = [self.arrPageTitles objectAtIndex:index];
        } else if (child.tag == 222) {
            ((UIImageView*)child).image = [UIImage imageNamed:[self.arrPageImages objectAtIndex:index]];
        }
    }
    
    return view;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            TRUE;
        }
        case iCarouselOptionArc:{
            return 2 * M_PI     ;
        }
            
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.0;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    self.pageIndex = carousel.currentItemIndex;
    [self.pageControl setCurrentPage:self.pageIndex];
    [self setUpTimer];
}

- (void) requestCheckFBExitsWithFBToken:(NSString *) fbToken{
    if (fbToken) {
        CheckFBExistParams * params = [[CheckFBExistParams alloc] initWithFBToken:fbToken device_id:[userDefaultManager getDeviceToken] app_id:[userDefaultManager getAppID] notification_token:[userDefaultManager getNotificationToken]];
        if (params) {
            [spinner startAnimating];
            API_CheckFBExist * api = [[API_CheckFBExist alloc] initWithParams:params];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                
                JSON_CheckFBExist * data = (JSON_CheckFBExist *) jsonObject;
                if (response.status) {
                    if (data.is_exist) {
                        out_auth_authorize * object = data.user;
                        [userDefaultManager saveAccessToken:object.access_token];
                        [userDefaultManager saveRefresh_Token:object.refresh_token];
                        [userDefaultManager getUserProfileData].gender = object.gender;
                        [userDefaultManager saveCredentialEjab:[userDefaultManager decryptDESByKey:[userDefaultManager getAppKey] data:object.cridential_ejab iv:[userDefaultManager getAppSecret]]];
                        [self requestGetProfileMeWith:object.access_token DeviceToken:[userDefaultManager getDeviceToken]];
                    } else {
                        [spinner stopAnimating];
                        [self navigateToUpdateInfoFB: data.fbId];
                    }
                    
                    [userDefaultManager setDidPostDailyLocalNotification:false];
                    [LocalNotificationHelper removeAllLocalNotifications];
                    
                } else {
                    [spinner stopAnimating];
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                [spinner stopAnimating];
            }];
        }
    }
    
}
- (void) navigateToUpdateInfoFB :(NSString *) fbAppId  {
    UpdateInfoFBViewController * updateVC = [[UpdateInfoFBViewController alloc] initWithNibName:@"UpdateInfoFBViewController" bundle:nil];
    updateVC.country_id = country_id;
    [self.navigationController pushViewController:updateVC animated:YES];
    
}

- (void) requestGetProfileMeWith:(NSString *) accessToken DeviceToken:(NSString *) deviceToken{
    if (accessToken && deviceToken) {
        API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:accessToken
                                                              device_token:deviceToken];
        [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
            out_profile_fetch * data = (out_profile_fetch *) json;
            [spinner stopAnimating];
            if (objStatus.status)
            {
                [userDefaultManager saveUserProfileData:data];
                [userDefaultManager removeM_ID];
                //                profileData = data;
                TabBarViewController *view = [[TabBarViewController alloc] initWithNibName:@"TabBarViewController" bundle:nil];
                [view setSelectedIndex:3];
                [self.navigationController pushViewController:view animated:TRUE];
            }else{
                [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Alert.Title.ErrorMessage"] message:objStatus.message];
            }
        } ErrorHandlure:^(NSError * error) {
            [spinner stopAnimating];
        }];
    }
}

- (void) showAlert: (NSString*) message {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@""
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle: [AppHelper getLocalizedString: @"Sign Up"]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    SignUpVC * signUpVC = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
                                    [self.navigationController pushViewController:signUpVC animated:true];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:[AppHelper getLocalizedString:@"CancelPopupRace.title"]
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

@end
