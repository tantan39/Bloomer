//
//  FlowerMenuPopUpViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/8/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "FlowerMenuPopUpViewController.h"
#import "UserProfileViewController.h"
#import "MyProfileViewController.h"

@interface FlowerMenuPopUpViewController ()
{
    UserDefaultManager *userDefaultManager;
    CGFloat backUpY;
}
@end

@implementation FlowerMenuPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        userDefaultManager = [[UserDefaultManager alloc] init];
        
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    _editorField.layer.cornerRadius = _editorField.frame.size.height / 2;
    _buttonCancel.clipsToBounds = YES;
    _buttonSend.clipsToBounds = YES;
    _buttonCancel.layer.cornerRadius = 15;
    _buttonSend.layer.cornerRadius = 15;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillShowNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIKeyboardWillHideNotification" object:nil];
    
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [self.view setFrame:aView.bounds];
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)touchSendButton:(id)sender {
    if (![_editorField.text isEqualToString:@""] && [_editorField.text integerValue] > 0)
    {
        NSInteger raceIndex = -1;
        
        if ([_parentView isKindOfClass:[RacesViewController class]]) {
            raceIndex = _iRace;
        }
        
//        flower_give *params = [[flower_give alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] num_flower:[_editorField.text integerValue] receiver:_uid type:k_USER post_id:@"" race_name:raceIndex];
//        flower_give_using *flowerGiveAPI = [[flower_give_using alloc] init];
//        [flowerGiveAPI selectInput:params];
//        flowerGiveAPI.myDelegate = self;
//        [flowerGiveAPI connect];
    }
    else
    {
        //[_warningLabel setHidden:FALSE];
        //_warningLabel.text = @"This number is invalid";
        
        [UIView animateWithDuration:.25 animations:^{
            [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
            [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height, _editorField.frame.size.width, _editorField.frame.size.height)];
            [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
            [_buttonSend setFrame:CGRectMake(_buttonSend.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonSend.frame.size.width, _buttonSend.frame.size.height)];
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
        
        [_editorField setBackgroundColor:[UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0]];
    }
}

//- (void)getDataFlower_give:(out_flower_give *)data
//{
//    if ([data getStt])
//    {
//        [userDefaultManager didTutorialGiveFlowerRace:TRUE];
//        [self removeAnimate];
//        
//        if ([_parentView isKindOfClass:[RacesViewController class]])
//        {
////            RacesViewController *view = (RacesViewController*)_parentView;
////            [view processAfterGivingFlower:data];
//        }
//        else
//            if ([_parentView isKindOfClass:[UserProfileViewController class]])
//            {
//                UserProfileViewController *view = (UserProfileViewController*)_parentView;
//                
//                out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
//                profileData.your_num_flower = data.my_nFlower;
//                [userDefaultManager saveUserProfileData:profileData];
//                [view.tabbar updateFlowerValue];
//                /* VL
//                view.flowerValue.text = @(data.model_nflower).stringValue;
//                
//                [view updateFlowerInProfileData:data.model_nflower];
//                [view initProfile];
//                [view AddThankYouView];
//                */
//            }
//            else
//                if ([_parentView isKindOfClass:[MyProfileViewController class]])
//                {
//                    MyProfileViewController *view = (MyProfileViewController*)_parentView;
//                    
//                    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
//                    profileData.your_num_flower = data.my_nFlower;
//                    profileData.num_received_flower = data.model_nflower;
//                    [userDefaultManager saveUserProfileData:profileData];
//                    //[view.tabbar updateFlowerValue];
//                    
//                    [view initProfile];
//                    [view AddThankYouView];
//                }
//
//        _editorField.text = @"";
//    }
//    else
//    {
//        if ([data getCode] == 479)
//        {
//            //[_warningLabel setHidden:FALSE];
//            //_warningLabel.text = @"This number is invalid";
//            
//            [UIView animateWithDuration:.25 animations:^{
//                [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
//                [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height, _editorField.frame.size.width, _editorField.frame.size.height)];
//                [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
//                [_buttonOK setFrame:CGRectMake(_buttonOK.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonOK.frame.size.width, _buttonOK.frame.size.height)];
//            } completion:^(BOOL finished) {
//                if (finished) {
//                }
//            }];
//        }
//        else
//            if ([data getCode] == 412)
//            {
//                [_warningLabel setHidden:FALSE];
//                _warningLabel.text = @"This exceeds the number of flowers you currently have!";
//                
//                [UIView animateWithDuration:.25 animations:^{
//                    [_popupView setFrame:CGRectMake(_popupView.frame.origin.x, backUpY - 20, _popupView.frame.size.width, _popupView.frame.size.height)];
//                    [_editorField setFrame:CGRectMake(_editorField.frame.origin.x, _warningLabel.frame.origin.y + _warningLabel.frame.size.height + 10, _editorField.frame.size.width, _editorField.frame.size.height)];
//                    [_buttonCancel setFrame:CGRectMake(_buttonCancel.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonCancel.frame.size.width, _buttonCancel.frame.size.height)];
//                    [_buttonOK setFrame:CGRectMake(_buttonOK.frame.origin.x, _editorField.frame.origin.y + _editorField.frame.size.height + 10, _buttonOK.frame.size.width, _buttonOK.frame.size.height)];
//                } completion:^(BOOL finished) {
//                    if (finished) {
//                    }
//                }];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                                message:[data getMegs]
//                                                               delegate:self
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
//                
//            }
//        
//        [_editorField setBackgroundColor:[UIColor colorWithRed:0.89 green:0.31 blue:0.31 alpha:1.0]];
//    }
//}

- (void) keyboardWillShow:(NSNotification *)note
{
//    NSDictionary *userInfo = [note userInfo];
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect kbSize = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbSize = [self.view convertRect:kbSize fromView:nil];
    
//    CGRect frame = _popupView.frame;
//    frame.origin.y = [UIScreen mainScreen].bounds.size.height - kbSize.size.height - _popupView.frame.size.height;
    
    CGFloat offSet = self.view.bounds.size.height - kbSize.size.height - (_buttonCancel.frame.origin.y + _buttonCancel.bounds.size.height + 10) ;
    
    if (offSet < 0) {
        [self.view setFrame:CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
   
}

- (void) keyboardWillHide:(NSNotification *)note
{
    //    NSDictionary *userInfo = [note userInfo];
    
    CGRect frame = _popupView.frame;
    if (IS_IPHONE_5)
    {
        frame.origin.y = 160;
    }
    else
        if (IS_IPHONE_4)
        {
            frame.origin.y = 125;
        }
    
    [UIView animateWithDuration:0.3 animations:^{
        _popupView.frame = frame;
    }];
}

@end
