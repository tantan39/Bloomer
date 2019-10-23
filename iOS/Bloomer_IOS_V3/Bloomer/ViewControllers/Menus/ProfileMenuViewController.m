//
//  ProfileMenuViewController.m
//  Xinh
//
//  Created by Truong Thuan Tai on 12/1/14.
//  Copyright (c) 2014 Glassegg. All rights reserved.
//


#import "ProfileMenuViewController.h"
#import "UIImage+StackBlur.h"

@interface ProfileMenuViewController ()
{
    ProfileMenuPopUpViewController *popup;
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    bool isLoadAvatar;
    bool isEditingStatus;
}
@end

@implementation ProfileMenuViewController
{
    NSArray* tableViewTitle;
    NSArray* tableViewImage;
}

@synthesize nameNotification, messageNotification, avataNotification;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isLoadAvatar = TRUE;
    isEditingStatus = FALSE;
    _bigAvatar.clipsToBounds = TRUE;
    
    tableViewTitle = [NSArray arrayWithObjects:@"Notification", @"Sponsors", @"Settings", @"Purchase",nil];
    tableViewImage = [NSArray arrayWithObjects:@"Ico_Notification_normal.png", @"Ico_Sponsor.png", @"Ico_AppSetting.png",@"Flower_Icon_Small.png" ,nil];
    
    _bottomNotification.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bottom_Notification.png"]];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [_status setEnabled:NO];
    _status.layer.shadowColor = [[UIColor blackColor] CGColor];
    _status.layer.shadowOffset = CGSizeMake(0, 1.0f);
    _status.layer.shadowOpacity = 1.0f;
    _status.layer.shadowRadius = 1.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:TRUE animated:TRUE];
    
    profile_me_using *profileAPI = [[profile_me_using alloc] initWithAccessToken:[userDefaultManager getAccessToken]];
    profileAPI.myDelegate = self;
    [profileAPI connect];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataProfile_me:(out_profile_fetch *)data
{
    [userDefaultManager saveUserProfileData:data];
    
    [self loadProfile];
}

- (void) loadProfile
{
    _smallAvatar.layer.borderWidth = 5.0f;
    _smallAvatar.layer.borderColor = [UIColor orangeColor].CGColor;
    _smallAvatar.layer.cornerRadius = _smallAvatar.frame.size.width / 2;
    _smallAvatar.clipsToBounds = YES;
    
    profileData = [userDefaultManager getUserProfileData];
    
    if (isLoadAvatar)
    {
        _avatarImageAPI =[[hImage alloc] initWithUserId:[NSString stringWithFormat:@"%ld",(long)[profileData uid]] andSize:@"l"];
        _avatarImageAPI.myDelegate = self;
        [_avatarImageAPI connect];
    }
    else
        isLoadAvatar = TRUE;
    
    _userName.text = profileData.name;
    _status.text = profileData.about_me;
    _location.text = profileData.living_in;
    
    if (profileData.rank != 0)
        _rank.text = [NSString stringWithFormat:@"#%ld @ Monthly Rank", (long)profileData.rank];
    else
        _rank.text = @"";
    
    _flowerValue.text = [NSString stringWithFormat:@"%ld", (long)profileData.num_received_flower];
    
    [self updateNotification:[userDefaultManager getNameNotify] message:[userDefaultManager getMessageNotify] andAvata:[userDefaultManager getPhotoNotify]];
    
    _sponsorValue.text = [NSString stringWithFormat:@"%ld", (long)profileData.sponsors];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"MenuCell";
    ProfileMenuButtonTableViewCell *cell = (ProfileMenuButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        if (IS_IPHONE_5)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ProfileMenuButtonTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        }
        else
            if (IS_IPHONE_4)
            {
                [tableView registerNib:[UINib nibWithNibName:@"ProfileMenuButtonTableViewCell_ip4" bundle:nil] forCellReuseIdentifier:identifier];
            }
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.buttonIcon.image = [UIImage imageNamed:[tableViewImage objectAtIndex:indexPath.row]];
    cell.buttonTitle.text = [tableViewTitle objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        
        SettingsViewController *view;
        if (IS_IPHONE_5)
        {
            view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        }
        else
            if (IS_IPHONE_4)
            {
                view = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_ip4" bundle:nil];
            }
        
        [self.navigationController pushViewController:view animated:TRUE];
    }
    if (indexPath.row == 1)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [userDefaultManager saveSponsorState:@"Menu"];
        
        SponsorListViewController *view;
        if (IS_IPHONE_5)
        {
            view = [[SponsorListViewController alloc]initWithNibName:@"SponsorListViewController" bundle:nil];
        }
        else
            if (IS_IPHONE_4)
            {
                view = [[SponsorListViewController alloc]initWithNibName:@"SponsorListViewController_ip4" bundle:nil];
            }
        
        [self.navigationController pushViewController:view animated:YES];
    }
    
    if (indexPath.row == 3)
    {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
        [userDefaultManager saveSponsorState:@"Menu"];
        PaymentViewController *view = [[PaymentViewController alloc]initWithNibName:@"PaymentViewController" bundle:nil];
        
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5)
        return 44;
    
    return 33;
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)editDidEnd:(id)sender {
    
    profile_update_about_me *params = [[profile_update_about_me alloc] initWithAccessToken:[userDefaultManager getAccessToken] andAbout_me:_status.text];
    profile_update_about_me_using *profileUpdateAboutMeAPI = [[profile_update_about_me_using alloc] init];
    [profileUpdateAboutMeAPI selectInput:params];
    profileUpdateAboutMeAPI.myDelegate = self;
    [profileUpdateAboutMeAPI connect];
    
    [_status setEnabled:NO];
    isEditingStatus = FALSE;
}

- (IBAction)touchEditStatusButton:(id)sender {
    isEditingStatus = TRUE;
    [_status setEnabled:TRUE];
    [_status becomeFirstResponder];
}

- (IBAction)touchEditAvatarButton:(id)sender {
    if (!isEditingStatus)
    {
        if (IS_IPHONE_5)
        {
            popup = [[ProfileMenuPopUpViewController alloc] initWithNibName:@"ProfileMenuPopUpViewController" bundle:nil];
        }
        else
            if (IS_IPHONE_4)
            {
                popup = [[ProfileMenuPopUpViewController alloc] initWithNibName:@"ProfileMenuPopUpViewController_ip4" bundle:nil];
            }
        
        popup.navigationController = self.navigationController;
        popup.parentView = self;
        
        [popup showInView:_reveal.view animated:TRUE];
    }
}

- (IBAction)touchSmallAvatarButton:(id)sender {
    MyProfileViewController *view;
    
    if (IS_IPHONE_5) {
        view = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
    }
    else
        if (IS_IPHONE_4)
        {
            view = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController_ip4" bundle:nil];
        }
    
    view.nav = self.navigationController;
    view.uid = profileData.uid;
    
    [self.navigationController setNavigationBarHidden:FALSE];
    [self.navigationController pushViewController:view animated:TRUE];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav_Top_Base.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _smallAvatar.image = chosenImage;
    UIImage *bigBluredImage = [chosenImage stackBlur:5];
    _bigAvatar.image = bigBluredImage;
    
    avatar_attached_using *avatarAPI = [[avatar_attached_using alloc] initWithAccessToken:[userDefaultManager getAccessToken] andImage:chosenImage];
    avatarAPI.myDelegate = self;
    [avatarAPI connect];
    
    isLoadAvatar = FALSE;
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    [popup removeAnimate];
}

-(void) getUIImage_hImage:(UIImage *)data
{
    _smallAvatar.image = data;
    
    UIImage *bigAvatarBlurredImage = [data stackBlur:5];
    _bigAvatar.image = bigAvatarBlurredImage;
}

- (void)getDataProfile_UpdateAboutMe:(out_profile_update *)data
{
    if ([data getStt])
    {
        profileData.about_me = data.about_me;
        [userDefaultManager saveUserProfileData:profileData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[data getMegs]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)updateNotification:(NSString*) name message:(NSString*)message andAvata:(NSString*) image
{
    if(name == nil)
    {
        name = @"";
        message = @"";
        image = @"noimage";
    }
    nameNotification.text = name;
    messageNotification.text = message;
    
    image_photo *photo = [[image_photo alloc] init];
    NSURL *imageURL = [NSURL URLWithString:[photo getPhotoParamPhotoId:image andSize:@"s" andFileType:@"jpg"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *imageInView = [UIImage imageWithData:imageData];
    avataNotification.image = imageInView;
    [userDefaultManager saveNotificationName:name message:message photo:image];
}

- (void)getDataAvatar_attached:(out_avatar_attached *)data
{
    if ([data getStt])
    {
    }
    else
    {
        
    }
}


@end
