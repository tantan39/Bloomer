//
//  SettingsAccountViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/12/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "SettingsAccountViewController.h"

@interface SettingsAccountViewController ()
{
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
}
@end

@implementation SettingsAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [self initNavigationBar];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
}

- (void)initNavigationBar
{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont systemFontOfSize:20.0];
    titleView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"Account";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SettingsProfileCell";
    SettingsProfileTableViewCell *cell = (SettingsProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SettingsProfileTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.title.text = @"Email";
            cell.content.text = profileData.email;
            break;
        case 1:
            cell.title.text = @"Phone Number";
            if(profileData.mobile ==(id)[NSNull null] || profileData.mobile.length == 0)
            {
                cell.content.text = @"";
            }
            else
            {
                cell.content.text = profileData.mobile;
            }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 5)
        return FALSE;
    
    return TRUE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)touchDoneButton
{
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)touchLogOutButton:(id)sender {
    auth_logout_using *auth_logout = [[auth_logout_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]];
    auth_logout.myDelegate = self;
    [auth_logout connect];
}

- (void) getDataLogout:(out_auth_logout *)data
{
    if ([data getStt])
    {
        [userDefaultManager removeAccessToken];
        [userDefaultManager removeNotification];
        
        MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        
        [self.navigationController setNavigationBarHidden: YES animated:YES];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_Top_Base.png"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController setViewControllers:[NSArray arrayWithObject:mainViewController] animated:TRUE];
    }
}

@end
