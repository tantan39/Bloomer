//
//  UpdateSignUpViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/3/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "UpdateSignUpViewController.h"
#import "UIColor+Extension.h"
#import "ConfirmationViewController.h"
#import "LocalNotificationHelper.h"

@interface UpdateSignUpViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    ImagePickerPopUpViewController *imagePickerPopup;
//    BOOL isChooseBirthday;
//    BOOL isChooseLocation;
    UIView *notificationView;
    NSTimer *closeInvitationBubbleTimer;
    NSTimer *closeErrorBubbleTimer;
    CGRect defaultFrame;
}
@end

@implementation UpdateSignUpViewController

//@synthesize isUploadedPhoto;

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    
    
//    isUploadedPhoto = FALSE;
//    isChooseBirthday = TRUE;
//    isChooseLocation = FALSE;
    
//    self.iconBubbleTriangleError.image = [self.iconBubbleTriangleError.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    [self.textFieldName roundedBorderCornerForTextField];
    [self.textFieldName setDefaultBorder];
    [self.textFieldName addLeftPaddingView];
    
    [self.tfIDName roundedBorderCornerForTextField];
    [self.tfIDName setDefaultBorder];
    [self.tfIDName addLeftPaddingView];
    
    [self.buttonMale setDefaultBorder];
    [self.buttonMale roundedBorderCornerForGenderButton];
    
    [self.buttonFemale roundedBorderCornerForGenderButton];
    [self.buttonComplete setStyleWhiteButton];
    
//    self.bubbleView.layer.cornerRadius = self.bubbleView.frame.size.height / 2;
//    self.bubbleView.clipsToBounds = true;
//    
//    self.bubbleErrorView.layer.cornerRadius = self.bubbleErrorView.frame.size.height / 2;
//    self.bubbleErrorView.clipsToBounds = true;
    
//    _location_id = 0;
    self.gender = FEMALE;
    [self.buttonFemale highlight:true];
    [self.buttonMale highlight:false];
//    [self.buttonComplete setWhiteButtonEnable:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    defaultFrame = self.view.frame;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    
    [[self navigationController] setNavigationBarHidden:TRUE animated:YES];
}



- (void)hideInvitationBubbleView{
    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.iconBubbleTriangle.alpha = 0;
//        self.bubbleView.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (finished)
//        {
//            self.iconBubbleTriangle.hidden = true;
//            self.bubbleView.hidden = true;
//        }
//    }];
}

- (void)hideInvitationBubbleErrorView{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.iconBubbleTriangleError.alpha = 0;
//        self.bubbleErrorView.alpha = 0;
//    } completion:^(BOOL finished) {
//        if (finished)
//        {
//            self.iconBubbleTriangleError.hidden = true;
//            self.bubbleErrorView.hidden = true;
//        }
//    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)photoPickerControllerDidCancel
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (touch.view != self.textFieldName)
    {
        [self.view endEditing:TRUE];
    }
    
    return YES;
}

// MARK: - Keyboard Observer.
- (void)keyboardWillShow:(NSNotification*)notif{
    
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_buttonComplete.frame.origin.y + _buttonComplete.bounds.size.height + 10);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notif{
    
//    self.mainViewCenterYConstraint.constant = 0;
//    [self.mainView setNeedsUpdateConstraints];
    
    
    NSDictionary *userInfo = [notif userInfo];
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = CGRectMake(defaultFrame.origin.x, defaultFrame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}

// MARK: - Actions

- (IBAction)textFieldNameEditingChanged:(id)sender{
    
    if (![self.textFieldName.text isEqualToString:@" "]){
        
        [self.buttonComplete setWhiteButtonEnable:YES];
    }
}


- (IBAction)touchBackButton:(id)sender
{
    if([[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2] isKindOfClass:[ConfirmationViewController class]]) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:true];
    }
    else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)touchChooseLocation:(id)sender
{
    ChooseLocationViewController *view = [[ChooseLocationViewController alloc] initWithNibName:@"ChooseLocationViewController" bundle:nil];
    view.parentView = self;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)touchButtonMale:(id)sender{
    self.gender = MALE;
    [self.buttonFemale highlight:false];
    [self.buttonMale highlight:true];
}

- (IBAction)touchButtonFemale:(id)sender{
    
    self.gender = FEMALE;
    [self.buttonFemale highlight:true];
    [self.buttonMale highlight:false];
}

- (IBAction)touchButtonExplaination:(id)sender{
    
//    self.iconBubbleTriangle.alpha = 0;
//    self.bubbleView.alpha = 0;
//    self.iconBubbleTriangle.hidden = false;
//    self.bubbleView.hidden = false;
    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.iconBubbleTriangle.alpha = 1;
//        self.bubbleView.alpha = 1;
//    } completion:^(BOOL finished) {
//        if (finished)
//        {
//            [closeInvitationBubbleTimer invalidate];
//            closeInvitationBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideInvitationBubbleView) userInfo:nil repeats:false];
//        }
//    }];
}

- (IBAction)touchButtonError:(id)sender
{
//    self.iconBubbleTriangleError.alpha = 0;
//    self.bubbleErrorView.alpha = 0;
//    self.iconBubbleTriangleError.hidden = false;
//    self.bubbleErrorView.hidden = false;
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.iconBubbleTriangleError.alpha = 1;
//        self.bubbleErrorView.alpha = 1;
//    } completion:^(BOOL finished) {
//        if (finished)
//        {
//            [closeErrorBubbleTimer invalidate];
//            closeErrorBubbleTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(hideInvitationBubbleErrorView) userInfo:nil repeats:false];
//        }
//    }];
}

- (IBAction)touchDoneButton:(id)sender
{
    if ([self.textFieldName validateDisplayName] && self.gender < BOTH_FEMALE_MALE){
        
//        [self.buttonComplete setEnabled:FALSE];
//        
//        avatar_attached_using *avatarAPI = [[avatar_attached_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]
//                                                                                 device_token:[userDefaultManager getDeviceToken]
//                                                                                        image:nil];
//        avatarAPI.myDelegate = self;
//        [avatarAPI connect];
        
        self.authRegister = [[auth_register alloc] initWithScreenName:self.textFieldName.text Photo_ID:nil Access_Token:[userDefaultManager getAccessToken] Device_Token:[userDefaultManager getDeviceToken] Location_ID:0 Birthday:@"" Gender:self.gender invite_code:nil];
        
        ChooseLocationViewController *view = [[ChooseLocationViewController alloc] initWithNibName:@"ChooseLocationViewController" bundle:nil];
        view.parentView = self;
        view.authRegister = self.authRegister;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        NSString * message = NSLocalizedString(@"Please enter your name!",);
        [AppHelper showMessageBox:nil message:message];
    }
}

@end
