//
//  UpdatePhoneNumberViewController.m
//  Bloomer
//
//  Created by Steven on 3/7/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "UpdatePhoneNumberViewController.h"
#import "AppHelper.h"
#import "UserDefaultManager.h"
#import "BloomerManager.h"
#import "LocationManager.h"
#import "API_Profile_ChangeMobile.h"
#import "ConfirmationViewController.h"
#import "VerifyUpdatePhoneNumberViewController.h"
#import "API_CheckMobileLinkFacebook.h"

@interface UpdatePhoneNumberViewController ()

@property (strong, nonatomic) UIBarButtonItem *doneButton;
@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (assign, nonatomic) NSInteger countryID;
@property (strong, nonatomic) NSMutableArray *countryList;
@property (strong, nonatomic) CountryPickerView *countryPickerView;

@end

@implementation UpdatePhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationBar];
    
    [[BloomerManager shareInstance] setCountryID:1];
    self.countryID = [BloomerManager shareInstance].countryID;
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    
    [self.phoneNumberTextField becomeFirstResponder];
    self.countryList = [BloomerManager shareInstance].listCountry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    [AppHelper changeNavigationBarToRed:self.navigationController];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self isMovingFromParentViewController])
    {
        // Pop
    }
    else
    {
        // Push
        [AppHelper changeNavigationBarToWhite:self.navigationController];
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    }
}

- (void)setupLanguage
{
    self.phoneNumberTextField.placeholder = [AppHelper getLocalizedString:@"UpdatePhoneNumber.phoneNumberTextFieldPlaceholder"];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:[AppHelper getLocalizedString:@"UpdatePhoneNumber.title"]];
    
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:[AppHelper getLocalizedString:@"UpdatePhoneNumber.doneButton"] style:UIBarButtonItemStyleDone target:self action:@selector(touchDoneButton)];
    self.doneButton.enabled = false;
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

- (void)setCountryBaseOnLocation
{
    Country* country = nil;
    for (int i = 0; i < self.countryList.count; i++)
    {
        Country* tmp = (Country*)[self.countryList objectAtIndex:i];
        NSString* currentCountryCode = [[LocationManager sharedInstance] getCountryCode];
        if ([currentCountryCode isEqualToString:tmp.countryShortName])
        {
            country = tmp;
        }
    }
    
    if (country)
    {
        [self didSelectCountry:country];
    }
}

// MARK: - Selectors
- (void)touchDoneButton
{
    NSString *phoneNumber = self.phoneNumberTextField.text;
    
    if (![self.phoneNumberTextField.text isEqualToString:@""])
    {
        __weak UpdatePhoneNumberViewController *weakSelf = self;
        API_CheckMobileLinkFacebook *apiCheckMobile = [[API_CheckMobileLinkFacebook alloc] initWithMobile:phoneNumber countryID:[[BloomerManager shareInstance] countryID] deviceToken:[self.userDefaultManager getDeviceToken]];
        [apiCheckMobile request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            if (response.status)
            {
                JSON_CheckMobileLinkFacebook *checkMobile = (JSON_CheckMobileLinkFacebook*)jsonObject;
                if(!checkMobile.existed) {
                    [weakSelf requestChangePhoneNumber:checkMobile.existed];
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
    }
}

-(void)requestChangePhoneNumber:(BOOL)linkWithExstedPhone {
    __weak UpdatePhoneNumberViewController *weakSelf = self;
    NSString *phoneNumber = self.phoneNumberTextField.text;
    mobile *parameters = [[mobile alloc] initWithAccess_Token:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] mobile:phoneNumber country_id:self.countryID];
    API_Profile_ChangeMobile *api = [[API_Profile_ChangeMobile alloc] initWithParams:parameters];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status)
        {
            weakSelf.phoneNumberTextField.text = @"";
            VerifyUpdatePhoneNumberViewController *view = [[VerifyUpdatePhoneNumberViewController alloc] initWithNibName:@"VerifyUpdatePhoneNumberViewController" bundle:nil];
            view.phoneNumber = phoneNumber;
            view.linkWithExistedPhone = linkWithExstedPhone;
            [weakSelf.navigationController pushViewController:view animated:true];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

// MARK: - Actions
- (IBAction)phoneNumberTextFieldEditingChanged:(id)sender
{
    if ([self.phoneNumberTextField.text isEqualToString:@""])
    {
        self.doneButton.enabled = false;
    }
    else
    {
        self.doneButton.enabled = true;
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


@end
