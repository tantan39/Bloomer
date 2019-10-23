//
//  ResetPasswordVerifyCodeViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/9/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ResetPasswordVerifyCodeViewController.h"
#import "Spinner.h"
#import "AppDelegate.h"

@interface ResetPasswordVerifyCodeViewController ()
{
    image_photo *imagePhotoAPI;
    Spinner *spinner;

    NSString* _phoneNumber;
     UserDefaultManager *userDefaultManager;
    NSInteger iCallSupportCount;
}

@end

@implementation ResetPasswordVerifyCodeViewController
@synthesize imgdotList, lblCodeList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_verifyButton setStatusEnable:NO];
    _verifyButton.layer.cornerRadius = self.verifyButton.frame.size.height/2;
    spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [_lblPhoneNumber setText:[NSString stringWithFormat:@"%@",_phoneNumber]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_codeField becomeFirstResponder];
}


- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)touchDoneButton:(id)sender {
    if (![_codeField.text  isEqual: @""])
    {
        //[spinner startAnimating];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        account_forget_verifycode *params = [[account_forget_verifycode alloc] initWithF_ID:_f_id active_code:_codeField.text];
        if (params) {
            API_Account_Forget_VerifyCode *verifyCodeAPI = [[API_Account_Forget_VerifyCode alloc] initWithParams:params];
            [verifyCodeAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                //[spinner stopAnimating];
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                if (response.status)
                {
                    ChangePasswordViewController *view;
                    
                    view = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
                    
                    view.f_id = _f_id;
                    [_codeField resignFirstResponder];
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
        [_lblMessage setText:@"Please enter your code"];
    }
}

- (IBAction)didChangeEdittingCodeField:(id)sender {
//    UITextField * tfVerifyCode = (UITextField *)sender;

    if (![_codeField.text isEqualToString:@""] && _codeField.text.length == 4) {
        [_verifyButton setBackgroundColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0]];
        [_verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_verifyButton setStatusEnable:TRUE];
        [self touchDoneButton:nil];
    } else {
        [_verifyButton setBackgroundColor:[UIColor clearColor]];
        [_verifyButton setTitleColor:[UIColor colorWithRed:0.125 green:0.125 blue:0.129 alpha:1.0] forState:UIControlStateNormal];
        [_verifyButton setStatusEnable:FALSE];
    }
}

- (IBAction)touchCodeField:(id)sender {
    //    [_greenDots setHidden:TRUE];
//    [self keyboardWillShow];
}

- (void)enableResendButton
{
    [_btnFreeSMS setEnabled:YES];
    [_lblMessage setText:@""];
}
- (void) enableVoiceCall{
    if (iCallSupportCount < 2) {
        [_btnFreeCall setEnabled:YES];
    }
    
    [_lblMessage setText:@""];
}

- (void)setVerifyCodeNumber:(NSString*)code
{
    [_codeField setText:code];
    [self.codeField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    for (int i = 0; i < [self.imgdotList count]; i++)
    {
        if (i < [code length])
        {
//            [self.imgdotList[i] setHidden:YES];
            [self.lblCodeList[i] setText:[NSString stringWithFormat:@"%c", [code characterAtIndex:i]]];
//            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[self.lblCodeList[i] text]];
//            [attributeString addAttribute:NSUnderlineStyleAttributeName
//                                    value:[NSNumber numberWithInt:1]
//                                    range:(NSRange){0,[attributeString length]}];
//            [self.lblCodeList[i] setAttributedText:attributeString];
        }
        else
        {
//            [self.imgdotList[i] setHidden:NO];
            [self.lblCodeList[i] setText:@""];
        }
        
    }
}

#pragma mark - Call Support
- (IBAction)btnFreeCall_Pressed:(id)sender {
    [_lblMessage setText:NSLocalizedString(@"Please wait up for 15s",nil)];
    [_btnFreeCall setEnabled:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableVoiceCall) userInfo:nil repeats:FALSE];
//    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    account_forget_who *params = [[account_forget_who alloc] initWithField:_phoneNumber countryCode:1];//VL-NOTEs country code is not safe.
    if (params) {
        API_Account_ForgetWho_VoiceCall *forgetWhoAPI = [[API_Account_ForgetWho_VoiceCall alloc] initWithParams:params];
        [forgetWhoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                iCallSupportCount++;
            }else
            {
                //        [_lblMessage setText:[data getMegs]];
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            //    [spinner stopAnimating];
            
            [_lblMessage setText:@""];
        }];
    }
    
}
- (IBAction)btnFreeSMS_Pressed:(id)sender {
    [_lblMessage setText:NSLocalizedString(@"Please wait up for 1 min",nil)];
    [_btnFreeSMS setEnabled:NO];
//    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    account_forget_who *params = [[account_forget_who alloc] initWithField:_phoneNumber countryCode:1];//VL-NOTEs country code is not safe.
    if (params) {
        API_Account_ForgetWho *forgetWhoAPI = [[API_Account_ForgetWho alloc] initWithParams:params];
        [forgetWhoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            //    [spinner stopAnimating];
            if (response.status)
            {
                
                [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
            }else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            //    [spinner stopAnimating];
            
            [_lblMessage setText:@""];
        }];
    }
    
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_verifyButton.frame.origin.y + _verifyButton.bounds.size.height + 5);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
    }];
}

#pragma - mark Textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:string];
    for (int i =0 ; i < [imgdotList count]; i++)
    {
        if(i < [text length])
        {
//            [imgdotList[i] setHidden:YES];
            if([[lblCodeList[i] text] isEqualToString:@""])
            {
                [lblCodeList[i] setText:string];
//                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[lblCodeList[i] text]];
//                [attributeString addAttribute:NSUnderlineStyleAttributeName
//                                        value:[NSNumber numberWithInt:1]
//                                        range:(NSRange){0,[attributeString length]}];
//                [lblCodeList[i] setAttributedText:attributeString];
            }
        }
        else
        {
//            [imgdotList[i] setHidden:NO];
            [lblCodeList[i] setText:@""];
        }
    }
    return [text length] <= 4;
}
@end
