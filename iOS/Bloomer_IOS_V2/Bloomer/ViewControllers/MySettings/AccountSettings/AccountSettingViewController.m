//
//  AccountSettingViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "UpdatePhoneNumberViewController.h"
#import "AccountSettingsCell.h"
#import "AppHelper.h"

#define PHONE_INDEX 0
#define EMAIL_INDEX 1
#define GENDER_INDEX 2
#define DOB_INDEX 3

@implementation AccountSettingsObject

- (id)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolder value:(NSString*)value
{
    self = [super init];
    if (self)
    {
        self.title = title;
        self.placeHolder = placeHolder;
        self.value = value;
    }
    return self;
}

@end

/////////////////////////////////////////////////////////////////

@interface AccountSettingViewController ()
{
}

@property (strong, nonatomic) NSMutableArray<AccountSettingsObject*>* accountSettingsData;
@property (strong, nonatomic) UserDefaultManager* userDefaultManager;

@end

@implementation AccountSettingViewController

+ (NSArray<AccountSettingsObject*>*)cellPrototypes
{
    return @[
             [[AccountSettingsObject alloc] initWithTitle:[AppHelper getLocalizedString:@"accountSettings.phoneNumber.title"] placeHolder:[AppHelper getLocalizedString:@"accountSettings.phoneNumber.placeHolder"] value:@""],
             [[AccountSettingsObject alloc] initWithTitle:[AppHelper getLocalizedString:@"accountSettings.email.title"] placeHolder:[AppHelper getLocalizedString:@"accountSettings.email.placeHolder"] value:@""],
             [[AccountSettingsObject alloc] initWithTitle:[AppHelper getLocalizedString:@"accountSettings.gender.title"] placeHolder:[AppHelper getLocalizedString:@"accountSettings.gender.placeHolder"] value:@""],
             [[AccountSettingsObject alloc] initWithTitle:[AppHelper getLocalizedString:@"accountSettings.dob.title"] placeHolder:[AppHelper getLocalizedString:@"accountSettings.dob.placeHolder"] value:@""]
             ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = NSLocalizedString(@"AccountSetting.NavigationName",nil);
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.accountSettingsData = [[AccountSettingViewController cellPrototypes] mutableCopy];
    
    UINib *accountSettingsNib = [UINib nibWithNibName:[AccountSettingsCell nibName] bundle:nil];
    [self.tableView registerNib:accountSettingsNib forCellReuseIdentifier:[AccountSettingsCell cellIdentifier]];
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initData {
    self.accountSettingsData[GENDER_INDEX].value = [self.userDefaultManager getGender] == FEMALE ? NSLocalizedString(@"Female",) : NSLocalizedString(@"Male",);
    self.accountSettingsData[PHONE_INDEX].value = self.profileSettings.mobile == nil ? @"" : [NSString stringWithFormat:@"%@%@", self.profileSettings.country_code, self.profileSettings.mobile];
    self.accountSettingsData[EMAIL_INDEX].value = self.profileSettings.email == nil ? @"" : self.profileSettings.email;
    self.accountSettingsData[DOB_INDEX].value = self.profileSettings.birthday == nil ? @"" : self.profileSettings.birthday;
    
    [self.tableView reloadData];
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEmail {
    self.accountSettingsData[EMAIL_INDEX].value = self.profileSettings.email == nil ? @"" : self.profileSettings.email;
    [self.tableView reloadData];
}

- (void)setMobile {
    self.accountSettingsData[PHONE_INDEX].value = self.profileSettings.mobile == nil ? @"" : [NSString stringWithFormat:@"%@%@", self.profileSettings.country_code, self.profileSettings.mobile];
    [self.tableView reloadData];
}

// MARK: - UITableViewDelegate, UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountSettingsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AccountSettingsCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountSettingsObject *data = self.accountSettingsData[indexPath.row];
    AccountSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:[AccountSettingsCell cellIdentifier] forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell changeStyle:[data.value isEqualToString:@""]];
    cell.labelTitle.text = data.title;
    cell.labelValue.text = [data.value isEqualToString:@""] ? data.placeHolder : data.value;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case PHONE_INDEX:
            {
                out_profile_fetch* profile = [self.userDefaultManager getUserProfileData];
                if ([profile.mobile isEqualToString:@""] || profile.mobile == nil || [profile.mobile isEqual:[NSNull null]]) {
                    UpdatePhoneNumberViewController *view = [[UpdatePhoneNumberViewController alloc] initWithNibName:@"UpdatePhoneNumberViewController" bundle:nil];
                    view.hidesBottomBarWhenPushed = true;
                    [self.navigationController pushViewController:view animated:true];
                } else {
                    if(profile.pass) {
                        EdittingAccountViewController *view;
                        view = [[EdittingAccountViewController alloc] initWithNibName:@"EdittingAccountViewController" bundle:nil];
                        if([self.profileSettings.mobile isEqual:[NSNull null]])
                        {
                            view.phoneText = @"";
                        }
                        else
                        {
                            view.phoneText = self.profileSettings.mobile;
                        }
                        view.parentView = self;
                        view.change = 3;
                        view.country_id = self.profileSettings.country_id;
                        
                        [self.navigationController pushViewController:view animated:YES];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                                       message:NSLocalizedString(@"UpdatePhoneNumber.needPass", nil)
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"PopUpMarketing.buttonClose", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            SetPasswordViewController *view = [[SetPasswordViewController alloc] initWithNibName:@"SetPasswordViewController" bundle:nil];
                            [self.navigationController pushViewController:view animated:YES];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                        return;
                    }
                }
                
                break;
            }
            
        case EMAIL_INDEX:
            {
                EdittingAccountViewController *viewController = [[EdittingAccountViewController alloc] initWithNibName:@"EdittingAccountViewController" bundle:nil];
                viewController.delegate = self;
                viewController.emailText = self.profileSettings.email;
                viewController.parentView = self;
                viewController.change = 2;
                
                [self.navigationController pushViewController:viewController animated:YES];
                break;
            }
            
        case GENDER_INDEX:
            {
                ChangesGenderViewController *view;
                view = [[ChangesGenderViewController alloc] initWithNibName:@"ChangesGenderViewController" bundle:nil];
                view.gender = [self.userDefaultManager getGender];
                
                [self.navigationController pushViewController:view animated:YES];
                break;
            }
            
        case DOB_INDEX:
            {
                EdittingAccountViewController *viewController = [[EdittingAccountViewController alloc] initWithNibName:@"EdittingAccountViewController" bundle:nil];
//                view.emailText = self.profileSettings.email;
                viewController.delegate = self;
                viewController.parentView = self;
                viewController.change = 4;
                viewController.birthday = self.profileSettings.birthday;
                
                [self.navigationController pushViewController:viewController animated:YES];
                break;
                
                break;
            }
            
        default:
            break;
    }
}

// MARK: - EdittingAccountDelegate

- (void)didUpdateEmail:(NSString *)email
{
    self.profileSettings.email = email;
    self.accountSettingsData[EMAIL_INDEX].value = email;
    [self.tableView reloadData];
}

- (void)didUpdateBirthday:(NSString *)birthday
{
    self.profileSettings.birthday = birthday;
    self.accountSettingsData[DOB_INDEX].value = birthday;
    [self.tableView reloadData];
}

@end
