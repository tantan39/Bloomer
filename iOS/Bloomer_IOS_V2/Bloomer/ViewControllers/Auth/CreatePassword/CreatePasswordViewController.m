//
//  CreatePasswordViewController.m
//  Bloomer
//
//  Created by Tran Thai Tan on 11/29/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "CreatePasswordViewController.h"

@interface CreatePasswordViewController (){
    UserDefaultManager * userDefaultManager;
    NSString * countryCode;
    BOOL isShowPass;
    UIImage * imgShowPass, * imgHidePass;
}

@end

@implementation CreatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    countryCode = @"";
    self.btnNext.layer.cornerRadius = self.btnNext.frame.size.height/2;
    [self.tfPassword setupPasswordUnderline];
    [self.btnNext setStatusEnable:NO];
    [self.tfPassword becomeFirstResponder];
    
    imgShowPass = [UIImage imageNamed:@"icon_eye"];
    imgHidePass = [UIImage imageNamed:@"icon_offeye"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 20 && range.length == 0)
    {
        return NO; // return NO to not change text
    }else{
        return YES
        ;}
}

- (IBAction)touchBackground:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)btnShowHidePass_Pressed:(id)sender {
    if (!isShowPass)
    {
        isShowPass = YES;
        [self.btnShowHidePass setImage:imgHidePass forState:UIControlStateNormal];
        
        [self.tfPassword setSecureTextEntry:NO];
    }else{
        isShowPass = NO;
        [self.btnShowHidePass setImage:imgShowPass forState:UIControlStateNormal];
        [self.tfPassword setSecureTextEntry:YES];
    }
}


- (IBAction)didChangePassword:(id)sender {
    if (![self.tfPassword validatePassword]) {
        [self.tfPassword setTextColor:[UIColor colorFromHexString:@"#A7A7A7"]];
        [self.btnNext setStatusEnable:NO];
    } else {
        [self.tfPassword setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self.btnNext setStatusEnable:YES];
    }
}


- (IBAction)btnBack_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnNext_Pressed:(id)sender {
    NSString * strPassword = self.tfPassword.text;

    [userDefaultManager saveUserPass:[NSString stringWithFormat:@"%@+|+%@", [NSString stringWithFormat:@"%@%@", countryCode, self.phoneNumber], [NSString md5:strPassword]]];
    
    switch ([[BloomerManager shareInstance] AuthenType]) {
        case Via_FACEBOOK:{
            UpdateInfoViewController * updateInfoVC = [[UpdateInfoViewController alloc] initWithNibName:@"UpdateInfoViewController" bundle:nil];
            [self.navigationController pushViewController:updateInfoVC animated:YES];
            break;
        }
        case Via_PHONENUMBER:{
            //Navigate to Update Info
            UpdateInfoViewController * updateInfoVC = [[UpdateInfoViewController alloc] initWithNibName:@"UpdateInfoViewController" bundle:nil];
            [self.navigationController pushViewController:updateInfoVC animated:YES];
            break;
        }
            
        default:
            break;
    }


}

#pragma mark - Handle Show/Hide Keyboard
- (void)keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGFloat yFrame = self.view.bounds.size.height - (_btnNext.frame.origin.y + _btnNext.bounds.size.height + 5);
    CGFloat offSet = yFrame - kbSize.height;
    
    if (offSet < 0) {
        [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
            self.view.frame = CGRectMake(0, offSet, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *) notif
{
    NSDictionary *userInfo = [notif userInfo];
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.frame = frame;
    }];
}

@end
