//
//  ResetPasswordViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/8/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "Spinner.h"
#import "AppDelegate.h"

@interface ResetPasswordViewController (){
    CGRect defaultFrame;
}

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _countryCode = @"+84";
    _countryShortName = @"VN";

    [_email addRightPaddingView];
    
    [_phoneNumberView roundedBorderCornerForTextField];
    [_phoneNumberView setDefaultBorder];
    [_doneButton setStyleWhiteButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    //    spinner = [[Spinner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) Color:[UIColor redColor]];
    //    [self.view addSubview:spinner];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_email becomeFirstResponder] ;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)touchDoneButton:(id)sender {
    
    if (![_email.text  isEqual: @""])
    {
        //[spinner startAnimating];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        account_forget_who *params = [[account_forget_who alloc] initWithField:_email.text countryCode:1];//VL-NOTEs country code is not safe.
        if (params) {
            API_Account_ForgetWho * api = [[API_Account_ForgetWho alloc] initWithParams:params];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                out_account_forget_who * data = (out_account_forget_who *) jsonObject;
                if (response.status)
                {
                    ResetPasswordVerifyCodeViewController *view;
                    
                    view = [[ResetPasswordVerifyCodeViewController alloc] initWithNibName:@"ResetPasswordVerifyCodeViewController" bundle:nil];
                    
                    view.f_id = data.f_id;
                    view.country_id = 1;
                    view.phoneNumber = _email.text;
                    //        view.uid = data.uid;
                    
                    [_email resignFirstResponder];
                    [self.navigationController pushViewController:view animated:TRUE];
                }
                else
                {
                    [AppHelper showMessageBox:nil message:response.message];
                }
            } ErrorHandlure:^(NSError *error) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
        }

    }
    else
    {
        [AppHelper showMessageBox:nil message:NSLocalizedString(@"Alert.Title.IncorectNumb", nil)];
    }
}


- (IBAction)touchRegionButton:(id)sender {
    //    ChooseRegionViewController *view;
    //
    //    if (IS_IPHONE_5)
    //    {
    //        view = [[ChooseRegionViewController alloc] initWithNibName:@"ChooseRegionViewController" bundle:nil];
    //    }
    
    ChooseRegionViewController *view = [[ChooseRegionViewController alloc] initWithNibName:@"ChooseRegionViewController" bundle:nil];
    
    view.parentView = (LoginViewController*)self;
    [_email resignFirstResponder];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)editEmail:(id)sender {
    if (![_email.text isEqual: @""]) {
        [_doneButton setEnabled:TRUE];
        _doneButton.backgroundColor = [UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [_doneButton setEnabled:FALSE];
        _doneButton.backgroundColor = [UIColor clearColor];
        [_doneButton setTitleColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0] forState:UIControlStateNormal];
    }
}

#pragma mark Handle Show/Hide Keyboard
- (void) keyboardWillShow:(NSNotification *) notif{
    
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_doneButton.frame.origin.y + _doneButton.bounds.size.height + 10);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
    
}

- (void) keyboardWillHide:(NSNotification *) notif{
    NSDictionary *userInfo = [notif userInfo];
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
}
@end
