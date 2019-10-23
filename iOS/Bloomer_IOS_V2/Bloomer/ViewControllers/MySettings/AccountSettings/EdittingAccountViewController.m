//
//  EdittingAccountViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/21/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "EdittingAccountViewController.h"
#import "API_CheckMobileLinkFacebook.h"
#import "BloomerManager.h"
#import "NotificationHelper.h"
#import "NSDate+Extension.h"
#import "UIColor+Extension.h"
#import "NSString+Extension.h"
#import "API_ProfileUpdateBirthday.h"
#import "AccountSettingViewController.h"
#import "API_Profile_UpdateName.h"
#import "API_Profile_UpdateUserName.h"
#import "API_Profile_ChangeEmail.h"
#import "UserDefaultManager.h"
#import "EditProfileViewController.h"
#import "CheckPasswordViewController.h"

@interface EdittingAccountViewController () {
    UserDefaultManager *userDefaultManager;
    UIBarButtonItem *doneButton;
    
    NSInteger age;
}

@property (assign, nonatomic) NSInteger countryID;
@property (strong, nonatomic) NSMutableArray *countryList;
@property (strong, nonatomic) CountryPickerView *countryPickerView;

@end

@implementation EdittingAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    age = 0;
    _nameView.layer.borderWidth = 1;
    _nameView.layer.borderColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.0].CGColor;
    _nameView.layer.cornerRadius = 18;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(textFieldText:)
                               name:UITextFieldTextDidChangeNotification
                             object:_textfieldContent];
    
    [self initNavigationBar];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_textfieldContent];
}

- (void)initView
{
    switch (self.change) {
        case 0:
        {
            self.coverViewHeight.constant = 0;
            self.countryViewWidth.constant = 0;
            self.birthdayButton.hidden = true;
            [self changeAllToBirthdayStyle:false];
            
            self.navigationItem.title = NSLocalizedString(@"NameChange.displayName",nil);
            self.displayName.text = NSLocalizedString(@"Display name",);
            self.character.text = NSLocalizedString(@"",nil);
            
            NSData *data = [self.nameText dataUsingEncoding:NSUTF8StringEncoding];
            NSString *goodValue = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
            
            [self.textfieldContent setText:goodValue];
            [self.textfieldContent addRegx:REGEX_DISPLAY_NAME withMsg:REGEX_DISPLAY_NAME_MSG];
            self.character.text = [NSString stringWithFormat:NSLocalizedString(@"NameChange.Title", ), self.textfieldContent.text.length];
            
            [self.textfieldContent becomeFirstResponder];
            [self.textfieldContent setValidateOnCharacterChanged:false];
            
            break;
        }
            
        case 1:
        {
            self.coverViewHeight.constant = 0;
            self.countryViewWidth.constant = 0;
            self.birthdayButton.hidden = true;
            [self changeAllToBirthdayStyle:false];
            
            self.navigationItem.title = NSLocalizedString(@"IDChange.displayName",nil);
            self.displayName.text = NSLocalizedString(@"ID Name",nil);
            self.character.text = NSLocalizedString(@"1 time change",nil);
            [self.textfieldContent setText:_nameText];
            [self.textfieldContent addRegx:REGEX_ID_NAME withMsg:nil];
            
            [self.textfieldContent becomeFirstResponder];
            [self.textfieldContent setValidateOnCharacterChanged:false];
            
            break;
        }
            
        case 2:
        {
            self.coverViewHeight.constant = 0;
            self.countryViewWidth.constant = 0;
            self.birthdayButton.hidden = true;
            [self changeAllToBirthdayStyle:false];
            
            self.navigationItem.title = [AppHelper getLocalizedString:@"edittingAccountSettings.email.navTitle"];
            [self.displayName setNumberOfLines:1];
            self.displayName.text = @"Email";
            self.character.text = @"";
            [self.textfieldContent setText:self.emailText];
            
            [self.textfieldContent becomeFirstResponder];
            self.textfieldContent.validateOnCharacterChanged = false;
            
            break;
        }
            
        case 3:
        {
            self.coverViewHeight.constant = 0;
            self.countryViewWidth.constant = 72;
            self.birthdayButton.hidden = true;
            [self changeAllToBirthdayStyle:false];
            
            self.countryID = self.country_id;
            [[BloomerManager shareInstance] setCountryID:self.country_id];
            self.countryList = [BloomerManager shareInstance].listCountry;
            
            for (Country* country in self.countryList) {
                if (country.countryID == self.countryID)
                {
                    [[BloomerManager shareInstance] setCountry_short_name:country.countryShortName];
                    self.countryCodeLabel.text = country.countryCode;
                    [self.iconFlag setImageWithURL:[NSURL URLWithString:country.countryFlag]];
                    
                    break;
                }
            }
            
            self.navigationItem.title = NSLocalizedString(@"UpdatePhoneNumber.title",nil);
            self.displayName.text = NSLocalizedString(@"Phone Number",nil);
            self.character.text = @"";
            [self.textfieldContent setText:_phoneText];
            
            [self.textfieldContent setKeyboardType:UIKeyboardTypePhonePad];
            [self.textfieldContent becomeFirstResponder];
            [self.textfieldContent setValidateOnCharacterChanged:false];
            
            break;
        }
            
        case 4:
        {
            self.coverViewHeight.constant = 145;
            self.countryViewWidth.constant = 0;
            self.birthdayButton.hidden = false;
            [self changeAllToBirthdayStyle:true];
            
            self.navigationItem.title = [AppHelper getLocalizedString:@"edittingAccountSettings.dob.navTitle"];
            self.displayName.text = [AppHelper getLocalizedString:@"edittingAccountSettings.dob.title"];
            self.character.text = @"";
            self.textfieldContent.text = self.birthday == nil ? [AppHelper getLocalizedString:@"accountSettings.dob.placeHolder"] : self.birthday;
            
            if (self.birthday != nil)
            {
                self.datePicker.date = [self.birthday convertToDateWithFormat:@"dd/MM/yyyy"];
            }
            
            break;
        }
            
        default:
            break;
    }
}

- (void)initNavigationBar
{
    doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done",nil) style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:doneButton, nil]];
}

- (void)changeAllToBirthdayStyle:(BOOL)change
{
    if (change)
    {
        self.displayName.font = [UIFont fontWithName:@"SFProText-Regular" size:16];
        self.displayName.textColor = [UIColor colorFromHexString:@"#232931"];
        self.textfieldContent.font = [UIFont fontWithName:@"SFProText-Medium" size:20];
        self.textfieldContent.textColor = [UIColor colorFromHexString:@"#232931"];
        self.textfieldContent.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        
        self.displayName.font = [UIFont fontWithName:@"SFProText-Medium" size:14];
        self.displayName.textColor = [UIColor colorFromHexString:@"#444444"];
        self.textfieldContent.font = [UIFont fontWithName:@"SFProText-Regular" size:14];
        self.textfieldContent.textColor = [UIColor colorFromHexString:@"#444444"];
        self.textfieldContent.textAlignment = NSTextAlignmentLeft;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (_change == 0) {
        return textView.text.length + (text.length - range.length) <= 20;
    } else {
        return textView.text.length + (text.length - range.length) <= 70;
    }
}

- (void)touchDoneButton {
    if([self.textfieldContent validate])
    {
        switch (self.change) {
            case 0:
            {
                name_update *param = [[name_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] name:_textfieldContent.text];
                if (param) {
                    API_Profile_UpdateName *api = [[API_Profile_UpdateName alloc] initWithParams:param];
                    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                        if (response.status) {
                            EditProfileViewController *view = (EditProfileViewController *)_parentView;
                            [view loadProfileMeUsingAPI];
                            
                            [NotificationHelper postNotificationForUpdatingProfileName:_textfieldContent.text];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [AppHelper showMessageBox:nil message:response.message];
                        }
                    } ErrorHandlure:^(NSError *error) {
                        
                    }];
                }
                

                break;
            }
            case 1:
            {
                username_update *param = [[username_update alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] username:_textfieldContent.text];
                if (param) {
                    API_Profile_UpdateUserName *api = [[API_Profile_UpdateUserName alloc] initWithParams:param];
                    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                        if (response.status) {
                            EditProfileViewController *view = (EditProfileViewController *)_parentView;
                            [view loadProfileMeUsingAPI];
                            
                            [NotificationHelper postNotificationForUpdatingProfileUsername:_textfieldContent.text];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else {
                            [AppHelper showMessageBox:nil message:response.message];
                        }
                    } ErrorHandlure:^(NSError *error) {
                    }];
                }

                break;
            }
            case 2:
            {
                if ([self.textfieldContent validateEmail])
                {
                    email *param = [[email alloc] initWithAccess_Token:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] email:_textfieldContent.text];
                    if (param) {
                        API_Profile_ChangeEmail *api = [[API_Profile_ChangeEmail alloc] initWithParams:param];
                        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                            if (response.status) {
                                [self.delegate didUpdateEmail:self.textfieldContent.text];
                                [self.navigationController popViewControllerAnimated:YES];
                            } else {
                                [AppHelper showMessageBox:nil message:response.message];
                            }
                        } ErrorHandlure:^(NSError *error) {
                            
                        }];
                    }
                }
                else
                {
                    [AppHelper showMessageBox:nil message:REGEX_EMAIL_MSG];
                }

                break;
            }
            case 3:
            {
//                NSLog(@"Country ID: %ld", (long)[BloomerManager shareInstance].countryID);
                NSString * phoneNumb = [[_textfieldContent text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *extractedString = [[phoneNumb componentsSeparatedByCharactersInSet:
                                              [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                             componentsJoinedByString:@""];
                API_CheckMobileLinkFacebook *request = [[API_CheckMobileLinkFacebook alloc] initWithMobile: extractedString countryID:[BloomerManager shareInstance].countryID deviceToken:[userDefaultManager getDeviceToken]];
                [request request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        JSON_CheckMobileLinkFacebook *checkMobile = (JSON_CheckMobileLinkFacebook*)jsonObject;
                        if(!checkMobile.existed) {
                            CheckPasswordViewController *view;
                            view = [[CheckPasswordViewController alloc] initWithNibName:@"CheckPasswordViewController" bundle:nil];
                            [view setPhoneNumber:[_textfieldContent text]];
                            [self.navigationController pushViewController:view animated:YES];
                        } else {
                            NSString *errorMessage = [AppHelper getLocalizedString:@"UpdatePhoneNumber.existedPhoneNumberError"];
                            [AppHelper showMessageBox:nil message:errorMessage];
                        }
                    }
                    else
                    {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
                break;
            }
            case 4:
            {
                if ([self.textfieldContent.text isEqualToString: [AppHelper getLocalizedString:@"accountSettings.dob.placeHolder"]]) {
                    [AppHelper showMessageBox:nil message:[AppHelper getLocalizedString:@"edittingAccountSettings.dob.input"]];
                    return;
                }
                if (age < 17) {
                    [AppHelper showMessageBox:nil message:[AppHelper getLocalizedString:@"SignUp.ValidateBirthday"]];
                    return;
                }
                API_ProfileUpdateBirthday *api = [[API_ProfileUpdateBirthday alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceToken:[userDefaultManager getDeviceToken] birthday:self.textfieldContent.text];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        [self.delegate didUpdateBirthday:self.textfieldContent.text];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( (_change == 0 && textField.text.length + string.length > 20 && range.length == 0)
       || (_change == 2 && textField.text.length + string.length > 30 && range.length == 0))

    {
        return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
}

- (IBAction)touchCountryFlagButton:(id)sender
{
    [self.view endEditing:true];
    
    if (self.countryList)
    {
        self.countryPickerView = [[CountryPickerView alloc] initWithFrame:self.view.bounds];
        self.countryPickerView.countryList = self.countryList;
        self.countryPickerView.delegate = self;
        [self.view addSubview:self.countryPickerView];
    }
}

// MARK: - Picker Delegate
- (void)didSelectCountry:(Country *)country{
    self.countryID = country.countryID;
    [[BloomerManager shareInstance] setCountryID:country.countryID];
    [[BloomerManager shareInstance] setCountry_short_name:country.countryShortName];
    
    self.countryCodeLabel.text = country.countryCode;
    [self.iconFlag setImageWithURL:[NSURL URLWithString:country.countryFlag]];

}

- (void)textFieldText:(id)notification
{
    if (_change == 0)
    {
        _character.text = [NSString stringWithFormat:NSLocalizedString(@"NameChange.Title", ), _textfieldContent.text.length];
    }
}

// MARK: - Actions
- (IBAction)touchBirthdayButton:(id)sender
{
    self.datePicker.hidden = false;
}

- (IBAction)datePickerChanged:(id)sender
{
    NSDate * birthday = self.datePicker.date;
    NSDate * now = [NSDate date];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthday toDate:now options:0];
    age = [components year];
    [self.textfieldContent setText:[self.datePicker.date toDayMonthYearFormat]];
}

- (IBAction)textfield_EditChange:(id)sender {
    if ([_textfieldContent.text isEqualToString:@""] || ![_textfieldContent validate]) {
        [doneButton setTintColor:[UIColor colorFromHexString:@"#B9C0C7"]];
        [doneButton setEnabled:NO];
        return;
    }
    [doneButton setTintColor:[UIColor whiteColor]];
    [doneButton setEnabled:YES];
}


- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
