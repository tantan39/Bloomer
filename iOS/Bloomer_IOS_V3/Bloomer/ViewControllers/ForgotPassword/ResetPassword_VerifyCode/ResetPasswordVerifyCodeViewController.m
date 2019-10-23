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
    UserDefaultManager *userDefaultManager;
    NSInteger iCallSupportCount;
    NSInteger f_id;
}

@end

@implementation ResetPasswordVerifyCodeViewController
@synthesize imgdotList, lblCodeList;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_verifyButton setStatusEnable:NO];
    _verifyButton.layer.cornerRadius = 4;
    spinner = ((AppDelegate *)[UIApplication sharedApplication].delegate).spinner;
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.codeField.delegate = self;
    [self setUp];
    [self setUpLabel];
//    [_lblMessage setText:NSLocalizedString(@"Please wait up for 1 min",nil)];
//    [_btnFreeSMS setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
//    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    BOOL isVN = [[BloomerManager shareInstance].country_short_name isEqualToString:@"vn"];
    [_btnFreeCall setUserInteractionEnabled:isVN];
    if(!isVN) {
        [_btnFreeCall setAlpha:0.3];
    }
    
    [AppHelper changeNavigationBarToWhite:self.navigationController];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [self btnFreeSMS_Pressed:nil];
    [_codeField becomeFirstResponder];

}

- (void) setUp {
    NSString *string = [NSString stringWithFormat:[AppHelper getLocalizedString: @"Support Label"], [AppHelper getLocalizedString:@"Support phone"], [AppHelper getLocalizedString:@"Support email"]];
    
    NSMutableAttributedString *stringAttribute  = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange rangePhone = [string rangeOfString:[AppHelper getLocalizedString:@"Support phone"]];
    
    [stringAttribute addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:rangePhone];
    
     NSRange rangeMail = [string rangeOfString:[AppHelper getLocalizedString:@"Support email"]];
    
    [stringAttribute addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]
                            range:rangeMail];
    self.labelSupport.attributedText = stringAttribute;
    
}

- (void) setUpLabel {
    for (UILabel * lb  in self.lblCodeList) {
        [self setBorderColor:lb color: [UIColor rgb:245 green:245 blue:245]];

    }
}

- (void) setBorderColor: (UILabel*) label color: (UIColor*) color {
    label.layer.cornerRadius= 4.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = [color CGColor];
    label.layer.borderWidth = 2.0f;
}

- (void) pushInputPassword {
    
    InputPasswordViewController *view;
    
    view = [[InputPasswordViewController alloc] initWithNibName: [AppHelper getScreenNameView:@"InputPasswordViewController"] bundle:nil];
    view.phoneNumber = self.phoneNumber;
    view.f_id = _f_id;
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)touchDoneButton:(id)sender {
    if (![_codeField.text  isEqual: @""])
    {
        [spinner startAnimating];
        [self.view endEditing:TRUE];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        account_forget_verifycode *params = [[account_forget_verifycode alloc] initWithF_ID:_f_id active_code:_codeField.text];
        if (params) {
            API_Account_Forget_VerifyCode *verifyCodeAPI = [[API_Account_Forget_VerifyCode alloc] initWithParams:params];
            [verifyCodeAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                [spinner stopAnimating];
                if (response.status)
                {
                    [self pushInputPassword];
                }
                else
                {
                    if (response.code == 464) {
                        [self pushInputPassword];
                    } else {
                        [_lblMessage setText:response.message];
                    }
                }
            } ErrorHandlure:^(NSError *error) {
                 [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
        }
        
    }
    else
    {
        [_lblMessage setText:NSLocalizedString(@"Please enter your code",nil)];
    }
}

- (IBAction)didChangeEdittingCodeField:(id)sender {
    
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
    [_btnFreeSMS setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    [_lblMessage setText:@""];
}
- (void) enableVoiceCall{
    if (iCallSupportCount < 2) {
        [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
    }
    
    [_lblMessage setText:@""];
}

- (void)setVerifyCodeNumber:(NSString*)code
{
    [_codeField setText:code];
    [self.codeField sendActionsForControlEvents:UIControlEventEditingChanged];
    
    for (int i = 0; i < [self.lblCodeList count]; i++)
    {
        if (i < [code length])
        {
            //            [self.imgdotList[i] setHidden:YES];
            [self.lblCodeList[i] setText:[NSString stringWithFormat:@"%c", [code characterAtIndex:i]]];
            [self setBorderColor: lblCodeList[i] color:[UIColor rgb:178 green:34 blue:37]];

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
    [_btnFreeCall setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(enableVoiceCall) userInfo:nil repeats:FALSE];
//    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    account_forget_who *params = [[account_forget_who alloc] initWithField:_phoneNumber countryCode:[BloomerManager shareInstance].countryID];//VL-NOTEs country code is not safe.
    if (params) {
        API_Account_ForgetWho_VoiceCall *forgetWhoAPI = [[API_Account_ForgetWho_VoiceCall alloc] initWithParams:params];
        [forgetWhoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                iCallSupportCount++;
                out_account_forget_who *json = (out_account_forget_who*)jsonObject;
                if(json) {
                    _f_id = json.f_id;
                }
            }else
            {
                //        [_lblMessage setText:[data getMegs]];
//                [AppHelper showMessageBox:nil message:response.message];
                [_lblMessage setText:response.message];

            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            //    [spinner stopAnimating];
            
            [_lblMessage setText:@""];
            [_btnFreeCall setStatusEnable:YES WithButtonType:GETVERIFYCODE_BUTTON];
        }];
    }
    
}
- (IBAction)btnFreeSMS_Pressed:(id)sender {
    [_lblMessage setText:NSLocalizedString(@"Please wait up for 1 min",nil)];
    [_btnFreeSMS setStatusEnable:NO WithButtonType:GETVERIFYCODE_BUTTON];
    
    account_forget_who *params = [[account_forget_who alloc] initWithField:_phoneNumber countryCode:[BloomerManager shareInstance].countryID];//VL-NOTEs country code is not safe.
    if (params) {
        API_Account_ForgetWho *forgetWhoAPI = [[API_Account_ForgetWho alloc] initWithParams:params];
        [forgetWhoAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            //    [spinner stopAnimating];
            if (response.status)
            {
                out_account_forget_who *json = (out_account_forget_who*)jsonObject;
                if(json) {
                    _f_id = json.f_id;
                }
                [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(enableResendButton) userInfo:nil repeats:FALSE];
            }else
            {
//                [AppHelper showMessageBox:nil message:response.message];
                [_lblMessage setText:response.message];

            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            
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
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
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
    if ([AppHelper isIP5AndIP4]) {
        return;
    }
    
    CGRect frame = self.view.frame;
    frame.origin.y = self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;;
    
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
                [self setBorderColor: lblCodeList[i] color:[UIColor rgb:178 green:34 blue:37]];
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
            [self setBorderColor:lblCodeList[i] color: [UIColor rgb:245 green:245 blue:245]];

        }
    }
    self.lblMessage.text = @"";
    return [text length] <= 4;
}

@end
