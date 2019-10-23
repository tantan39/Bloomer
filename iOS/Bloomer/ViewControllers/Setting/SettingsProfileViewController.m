//
//  SettingsProfileViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/10/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//

#import "SettingsProfileViewController.h"

@interface SettingsProfileViewController ()
{
    NSArray *titleArray;
    NSArray *contentArray;
    out_profile_fetch *profileData;
    UserDefaultManager *userDefaultManager;
    BOOL isChangedAvatar;
}
@end

@implementation SettingsProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArray = [NSArray arrayWithObjects:@"Display Name", @"Email", @"", @"D.O.B", @"Gender", nil];
    contentArray = [NSArray arrayWithObjects:@"", @"", @"", @"dd/mm/yyyy", @"Choose a Gender", nil];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profile_me_using *profileMeAPI = [[profile_me_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]];
    profileMeAPI.myDelegate = self;
    [profileMeAPI connect];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    [self initNavigationBar];
    
    [_buttonList setFrame:CGRectMake(_buttonList.frame.origin.x, _buttonList.frame.origin.y, _buttonList.frame.size.width, 44 * 6)];
    [_homePageButton setEnabled:FALSE];
    profileData = [[out_profile_fetch alloc] init];
    
    isChangedAvatar = FALSE;
}

- (void)initNavigationBar
{
    if ([[userDefaultManager getUserState] isEqual:@"signup"])
    {
        [self.navigationItem setHidesBackButton:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"DONE" style:UIBarButtonItemStylePlain target:self action:@selector(touchDoneButton)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.navigationController setNavigationBarHidden:FALSE];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    if ([userDefaultManager getBackFromSettingsEditorState])
    {
        [_buttonList reloadData];
        [userDefaultManager removeBackFromSettingsEditorState];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SettingsProfileCell";
    SettingsProfileTableViewCell *cell = (SettingsProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"SettingsProfileTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.title.text = [titleArray objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
            cell.content.text = profileData.name;
            break;
        case 1:
            cell.content.text = profileData.email;
            break;
        case 3:
            cell.content.text = profileData.birthday;
            break;
        case 4:
            if (profileData.gender == 0)
                cell.content.text = @"Female";
            else
                cell.content.text = @"Male";
            break;
            
    }
    
    if (indexPath.row == 2)
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 2 && indexPath.row != 5 && indexPath.row != 1 && [[userDefaultManager getUserState] isEqualToString:@"signup"])
    {
        SettingsEditViewController *view;
        if (IS_IPHONE_5)
        {
            view = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
        }
        else
            if (IS_IPHONE_4)
            {
                view = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController_ip4" bundle:nil];
            }
        
        view.viewType = indexPath.row;
        view.profileData = profileData;
        [self.navigationController pushViewController:view animated:TRUE];
    }
    else
        if (indexPath.row != 2 && indexPath.row != 5 && indexPath.row != 1 && indexPath.row != 4 && [[userDefaultManager getUserState] isEqualToString:@"login"])
        {
            SettingsEditViewController *view;
            if (IS_IPHONE_5)
            {
                view = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController" bundle:nil];
            }
            else
                if (IS_IPHONE_4)
                {
                    view = [[SettingsEditViewController alloc] initWithNibName:@"SettingsEditViewController_ip4" bundle:nil];
                }
            
            view.viewType = indexPath.row;
            view.profileData = profileData;
            [self.navigationController pushViewController:view animated:TRUE];
        }
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
    if ([[userDefaultManager getUserState] isEqual:@"signup"] && !isChangedAvatar)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                        message:@"Please upload your avatar"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([[userDefaultManager getUserState] isEqual:@"login"])
        {
            [self.navigationController setNavigationBarHidden:FALSE];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else
        {
            
            SWRevealViewController *view = [[SWRevealViewController alloc] init];
            
            [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"Btn_Back_Normal.png"]];
            [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"Btn_Back_Normal.png"]];
            [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
            view.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
            
            RaceViewController *race = [[RaceViewController alloc] initWithNibName:@"RaceViewController" bundle:nil];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:race];
            SWRevealViewControllerSegue *raceSegue = [[SWRevealViewControllerSegue alloc] initWithIdentifier:@"sw_front" source:view destination:navigationController];
            [view prepareForSegue:raceSegue sender:0];
            [raceSegue perform];
            
            [userDefaultManager saveUserState:@"login"];
            [self.navigationController setNavigationBarHidden:TRUE];
            [self.navigationController pushViewController:view animated:TRUE];
        }
        
        profile_update *params = [[profile_update alloc] initWithAccess_Token:[userDefaultManager getAccessToken] screenName:profileData.name mobile:@"0123456789" gender:profileData.gender living:profileData.living_in about:profileData.about_me birthday:profileData.birthday];
        profile_update_using *profileUpdateAPI = [[profile_update_using alloc] init];
        [profileUpdateAPI selectInput:params];
        profileUpdateAPI.myDelegate = self;
        [profileUpdateAPI connect];
        
        avatar_attached_using *avatarAPI = [[avatar_attached_using alloc] initWithAccessToken:[userDefaultManager getAccessToken] andImage:_avatar.image];
        avatarAPI.myDelegate = self;
        [avatarAPI connect];
    }
}

- (void)getDataProfileUpdate:(out_profile_update *)data
{
    if ([data getStt])
    {
        [userDefaultManager saveUserProfileData:profileData];
    }
}

- (void)getDataProfile_me:(out_profile_fetch *) data
{
    if ([data getStt])
    {
        profileData = data;
        _info.text = data.email;
        
        image_photo *imagePhotoAPI = [[image_photo alloc] init];
        NSData *avatarData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[imagePhotoAPI getImageParamUserId:data.uid andSize:@"l"]]];
        _avatar.image = [UIImage imageWithData:avatarData];
        
        [_buttonList reloadData];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_Top_Base.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _avatar.image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    isChangedAvatar = TRUE;
}

- (void)getDataAvatar_attached:(out_avatar_attached *)data
{
    if ([data getStt])
    {
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification"
                                                        message:[data getMegs]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)touchAvatarButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:imagePicker animated:TRUE completion:nil];
}

@end
