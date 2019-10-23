//
//  EditProfileViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppHelper.h"
#import "API_Profile_BannerFetches.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"
#import "API_Profile_Me.h"
#import "UIImageView+AFNetworking.h"
#import "API_Profile_AvatarsFetches.h"
#import "ChangeBannerViewController.h"
#import "ChangeAvatarViewController.h"
#import "EdittingAccountViewController.h"
#import "ChangeCaptionViewController.h"
#import "ChooseLocationViewController.h"
#import "UIImage+Utilities.h"
#import "SelectCityViewController.h"

#define WIDTH_SCREEN [[UIScreen mainScreen] bounds].size.width

@interface EditProfileViewController () {
    UserDefaultManager *userDefaultManager;
    out_profile_fetch *profileData;
    NSMutableArray *bannerList;
    NSMutableArray *avatarList;
    NSSortDescriptor *sortDescriptor;
    NSArray *sortDescriptors;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    bannerList = [[NSMutableArray alloc] init];
    avatarList = [[NSMutableArray alloc] init];
    
    _avatar1.layer.cornerRadius = _avatar1.frame.size.width / 2;
    _avatar1.clipsToBounds = TRUE;
    _avatar1.layer.borderWidth = 1;
    _avatar1.layer.borderColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.0].CGColor;
    
    _avatar2.layer.cornerRadius = _avatar2.frame.size.width / 2;
    _avatar2.clipsToBounds = TRUE;
    _avatar2.layer.borderWidth = 1;
    _avatar2.layer.borderColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.0].CGColor;
    
    _avatar3.layer.cornerRadius = _avatar3.frame.size.width / 2;
    _avatar3.clipsToBounds = TRUE;
    _avatar3.layer.borderWidth = 1;
    _avatar3.layer.borderColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.0].CGColor;
    
    _avatar4.layer.cornerRadius = _avatar4.frame.size.width / 2;
    _avatar4.clipsToBounds = TRUE;
    _avatar4.layer.borderWidth = 1;
    _avatar4.layer.borderColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.0].CGColor;
    
    [_uploadAvatarView setHidden:![userDefaultManager getUserProfileData].isupload_avatar];
    
    [self loadProfileMeUsingAPI];
//    [self loadSlideShowUsingAPI];
    [self loadAvatars];
    [self initNavigationBar];
}

- (void) initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Edit Profile", nil)];
}

- (IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadSlideShowUsingAPI];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)loadProfileMeUsingAPI
{
//    profile_me_using *profileMeAPI = [[profile_me_using alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
//    profileMeAPI.myDelegate = self;
//    [profileMeAPI connect];
    API_Profile_Me * api = [[API_Profile_Me alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        out_profile_fetch * data = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            profileData = data;
            [userDefaultManager saveUserProfileData:profileData];
            
            [self initProfile];
        }
        else
        {
            [AppHelper showMessageBox:nil message:objStatus.message];
        }

    } ErrorHandlure:^(NSError * error) {
        
    }];
}

//- (void)getDataProfile_me:(out_profile_fetch *)data
//{
//    if ([data getStt])
//    {
//        profileData = data;
//        [userDefaultManager saveUserProfileData:profileData];
//        
//        [self initProfile];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[data getTitle]
//                                                        message:[data getMegs]
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

- (void)initProfile {
//    [_nameButton setTitle:profileData.name forState:UIControlStateNormal];
//    _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_nameLabel setText:profileData.name];
//    [_idNameButton setTitle:profileData.username forState:UIControlStateNormal];
    //    _idNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_idnameLabel setText:profileData.username];

    _caption.text = profileData.about_me;
    _location.text = [NSString stringWithFormat:NSLocalizedString(@"Location: %@",), profileData.location_name];
}

- (void)loadSlideShowUsingAPI {
    API_Profile_BannerFetches *api = [[API_Profile_BannerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                               device_token:[userDefaultManager getDeviceToken]
                                                                                        uid:profileData.uid];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
            bannerList = data.bannerList;
            
            if (bannerList.count != 0) {
                [self initSlideShow];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
    }];

}

- (void)initSlideShow {
    for (int i = 0; i < bannerList.count; i++) {
        BannerObj *temp = (BannerObj *)[bannerList objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH_SCREEN * i, 0, WIDTH_SCREEN, _slideshow.frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        
        [UIImage loadImageFromURL:temp.photo_url SuccessBlock:^(UIImage * img) {
            imageView.image = img;
        }];
        
        [_slideshow addSubview:imageView];
        
        _slideshow.contentSize = CGSizeMake(bannerList.count * WIDTH_SCREEN, _slideshow.frame.size.height);
    }
}

- (void)loadAvatars {
    API_Profile_AvatarsFetches *api = [[API_Profile_AvatarsFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatars_fetches * data = (out_avatars_fetches *) jsonObject;
        if (response.status) {
            //re-order avatar list by category
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryID" ascending:YES];
            sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            //        avatarList = [data avatarList];
            avatarList = [[[data avatarList] sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            [self initAvatars];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];

}

- (void)initAvatars {
    if (avatarList.count == 1) {
        avatar *temp = [avatarList objectAtIndex:0];
        [_avatar1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar1 setHidden:FALSE];
        [_avatar2 setHidden:TRUE];
        [_avatar3 setHidden:TRUE];
        [_avatar4 setHidden:TRUE];
    } else if (avatarList.count == 2) {
        avatar *temp = [avatarList objectAtIndex:0];
        avatar *temp1 = [avatarList objectAtIndex:1];
         [_avatar1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
         [_avatar2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp1.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar1 setHidden:FALSE];
        [_avatar2 setHidden:FALSE];
        [_avatar3 setHidden:TRUE];
        [_avatar4 setHidden:TRUE];
    } else if (avatarList.count == 3) {
        avatar *temp = [avatarList objectAtIndex:0];
        avatar *temp1 = [avatarList objectAtIndex:1];
        avatar *temp2 = [avatarList objectAtIndex:2];
        [_avatar1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp1.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar3 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp2.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar1 setHidden:FALSE];
        [_avatar2 setHidden:FALSE];
        [_avatar3 setHidden:FALSE];
        [_avatar4 setHidden:TRUE];
    } else if (avatarList.count >= 4) {
        avatar *temp = [avatarList objectAtIndex:0];
        avatar *temp1 = [avatarList objectAtIndex:1];
        avatar *temp2 = [avatarList objectAtIndex:2];
        avatar *temp3 = [avatarList objectAtIndex:3];
        [_avatar1 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar2 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp1.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar3 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp2.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar4 setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp3.photo_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10] placeholderImage:nil success:nil failure:nil];
        [_avatar1 setHidden:FALSE];
        [_avatar2 setHidden:FALSE];
        [_avatar3 setHidden:FALSE];
        [_avatar4 setHidden:FALSE];
    } else {
        [_avatar1 setHidden:TRUE];
        [_avatar2 setHidden:TRUE];
        [_avatar3 setHidden:TRUE];
        [_avatar4 setHidden:TRUE];
    }
}

- (IBAction)touchChangeBanner:(id)sender {
    if (bannerList.count > 0)
    {
        ChangeBannerViewController *view = [[ChangeBannerViewController alloc] initWithNibName:@"ChangeBannerViewController" bundle:nil];
        view.bannerList = bannerList;
        view.hidesBottomBarWhenPushed = true;
        
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (IBAction)touchChangeAvatar:(id)sender {
    if (avatarList.count > 0)
    {
        if([profileData.city.city_short_name isEqualToString:k_UNKNOWN_LOCATION]) {
            SelectCityViewController *view = [[SelectCityViewController alloc] initWithNibName:@"SelectCityViewController" bundle:nil];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        } else {
            ChangeAvatarViewController *view;
            view = [[ChangeAvatarViewController alloc] initWithNibName:@"ChangeAvatarViewController" bundle:nil];
            view.avatarList = avatarList;
            view.parentView = self;
            view.hidesBottomBarWhenPushed = true;
            
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

- (IBAction)touchChangeName:(id)sender {
    EdittingAccountViewController *view;
    view = [[EdittingAccountViewController alloc] initWithNibName:@"EdittingAccountViewController" bundle:nil];
    view.nameText = profileData.name;
    view.parentView = self;
    view.change = 0;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)touchChangeUsername:(id)sender {
    EdittingAccountViewController *view = [[EdittingAccountViewController alloc] initWithNibName:@"EdittingAccountViewController" bundle:nil];
    view.nameText = profileData.username;
    view.parentView = self;
    view.change = 1;
    
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)touchStatus:(id)sender {
    ChangeCaptionViewController *view;
    view = [[ChangeCaptionViewController alloc] initWithNibName:@"ChangeCaptionViewController" bundle:nil];
    view.parentView = self;
    view.caption = _caption.text;
    
    [self.navigationController pushViewController:view animated:YES];
}

@end
