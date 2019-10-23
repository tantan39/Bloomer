//
//  ImagePickerRaceViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ImagePickerRaceViewController.h"
#import "MyProfileViewController.h"
#import <DZNPhotoPickerController/UIImagePickerController+Edit.h>
#import "NotificationHelper.h"
#import "BloomerAlbumViewController.h"
#import "PhotoGalleryViewController.h"

@interface ImagePickerRaceViewController () {
    UserDefaultManager *userDefaultManager;
    UIImage *chosenImage;
    RacesViewController *  RaceView;
    UIView *aPreviousView;
    out_profile_fetch *profileData;
    NSMutableArray* listGallery;
}

@end

@implementation ImagePickerRaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        userDefaultManager = [[UserDefaultManager alloc] init];
        
        profileData = [userDefaultManager getUserProfileData];
        
        for (UIView *view in [[[UIApplication sharedApplication] delegate] window].subviews) {
            if ([view isKindOfClass:[MKNumberBadgeView class]])
            {
                _badgeNumber = (MKNumberBadgeView *)view;
                break;
            }
        }
        
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
        if(IS_IPHONE_4)
        {
            CGRect frame = self.view.frame;
            frame.size.height -= DELTA_IPHONE_4;
            self.view.frame = frame;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _avatar.clipsToBounds = TRUE;
    _doneButton.layer.cornerRadius = 12;
    _uploadView.layer.cornerRadius = 12;
//    [_avatar setImage:_avatarReceived];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.view addGestureRecognizer:tap];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateShowingNofitication];
    
    [self.lblTitle setText:NSLocalizedString(@"GetImageRace.tittle",)];
    _lblTitle.numberOfLines = 2;
    [_uploadFrom setText:[NSString stringWithFormat:NSLocalizedString(@"GetImageRace.upload",)]];
    
    [_galleryButton setTitle:NSLocalizedString(@"GetImageRace.Library",) forState:UIControlStateNormal];
    [_cameraButton setTitle:NSLocalizedString(@"GetImageRace.Photo",) forState:UIControlStateNormal];
    
}

- (void)closePopup {
    [self removeAnimate];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    aPreviousView = aView;
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        [self.view setFrame:[UIApplication sharedApplication].keyWindow.bounds];
        [self.view layoutIfNeeded];
        if (animated) {
            [self showAnimate];
        }
    });
}

-(void) viewWillAppear:(BOOL)animated
{
    if(_avatarReceived == nil)
    {
        [_doneButton setTitle:NSLocalizedString(@"UpdateAvatar.Cancel",) forState:UIControlStateNormal];
    }
    else
    {
        
        [_doneButton setTitle:NSLocalizedString(@"GetImageRace.Done",) forState:UIControlStateNormal];
    }
}

- (IBAction)touchCamera:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        
        
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [weakSelf handleImagePicker:picker withMediaInfo:info];
        }
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [weakSelf dismissController:picker];
    };
    
    [self presentController:picker sender:sender];
}

- (IBAction)touchGallery:(id)sender {
    __weak ImagePickerRaceViewController* weakSelf = self;
    
    PhotoGalleryViewController *viewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:nil];
    viewController.hidesBottomBarWhenPushed = true;
    viewController.parentView = self.parentView;
    viewController.isMultipleChoice = false;
    viewController.chosePhoto = ^(UIImage *chosenImage) {
        weakSelf.selectedPhoto = chosenImage;
        weakSelf.avatar.image = chosenImage;
        [weakSelf bringThisViewToFront];
    };
    viewController.cancelChoosePhoto = ^{
        [weakSelf bringThisViewToFront];
    };
    
    [self sendThisViewToBack];
    [self.parentView.navigationController pushViewController:viewController animated:true];
}

- (IBAction)touchDone:(id)sender {
    if(_avatarReceived != nil){
        [_doneButton setEnabled:NO];
        [_galleryButton setEnabled:NO];
        [_cameraButton setEnabled:NO];
        [_BloomerAlbumButton setEnabled:NO];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
        
        API_Avatar_Attached *api = [[API_Avatar_Attached alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] image:_avatarReceived];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_avatar_attached * data = (out_avatar_attached *) jsonObject;
            if (response.status)
            {
                [[userDefaultManager getUserProfileData] setIsupload_avatar:YES];
                if (self.categoryType > RACECATEGORY_LOCATION) {
                    [self invoke_API_JoinRaceWith:data.photo_id];
                } else {
                    if ([_parentView isKindOfClass:[RacesViewController class]]) {
                        RacesViewController *view = (RacesViewController *)_parentView;
                        view.isJoin = RACE_JOINED;
                        [view pullToRefresh];
                        _parentView.hidesBottomBarWhenPushed = NO;
                        [self.myNavigationController popToViewController:view animated:TRUE];
                    }
                    else
                    {
                        [self.myNavigationController popToRootViewControllerAnimated:true];
                        [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:self.key timeStampKey:nil];
                    }
                    
                    [self removeAnimate];
                }
            }
            else
            {
                [_doneButton setEnabled:YES];
                [_galleryButton setEnabled:YES];
                [_cameraButton setEnabled:YES];
                [_BloomerAlbumButton setEnabled:YES];
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];


    } else{
        
        [self closePopup];
    }
}

- (void)invoke_API_JoinRaceWith:(NSString *)photoID {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_JoinRace *api = [[API_JoinRace alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:self.key photoID:photoID];
    
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
        [self.doneButton setEnabled:true];
        if (response.status) {
            if ([_parentView isKindOfClass:[RacesViewController class]]) {
                RacesViewController *view = (RacesViewController *)_parentView;
                view.isJoin = RACE_JOINED;
                [view pullToRefresh];
                _parentView.hidesBottomBarWhenPushed = NO;
                [self.myNavigationController popToViewController:view animated:TRUE];
            } else {
                [self.myNavigationController popToRootViewControllerAnimated:true];
                [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:self.key timeStampKey:nil];
            }
            
            [self removeAnimate];
        } else {
            [_doneButton setEnabled:YES];
            [_galleryButton setEnabled:YES];
            [_cameraButton setEnabled:YES];
            [_BloomerAlbumButton setEnabled:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:response.message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } ErrorHandlure:^(NSError *error) {
       [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadGallery {
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Profile_Gallery_Fetches *API = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:[profileData uid]];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status) {
            listGallery = [data galleryList];
            
            BloomerAlbumViewController *viewController = [[BloomerAlbumViewController alloc] initWithNibName:@"BloomerAlbumViewController" bundle:nil];
            viewController.galleryList = [data galleryList];;
            viewController.hidesBottomBarWhenPushed = true;
            viewController.parentView = self.parentView;
            viewController.chosePhoto = ^(UIImage *Img) {
                self.selectedPhoto = Img;
                self.avatar.image = Img;
                [self bringThisViewToFront];
            };
            viewController.cancelChoosePhoto = ^{
                [self bringThisViewToFront];
            };
            
            [self sendThisViewToBack];
            [self.parentView.navigationController pushViewController:viewController animated:true];
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}


- (void)sendThisViewToBack
{
    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self.view];
}

- (void)bringThisViewToFront
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.view];
}

- (void)bringViewToFront:(UIView*)view
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];
}

- (IBAction)TouchAlbum:(id)sender {
    [self loadGallery];

    
}

//- (void)getDataAvatarRace_attached:(out_avatar_attached *)data
//{
//    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
//    [_doneButton setEnabled:YES];
//    if ([data getStt])
//    {
//        UINavigationController *navigation = [_parentView.tabBarController.viewControllers objectAtIndex:1];
//        MyProfileViewController *view = (MyProfileViewController*)[navigation.viewControllers firstObject];
//        
//        if (view.isViewLoaded) {
//            [view initProfile];
//        }
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


- (void)ChoosingPageAvatar:(UIImage *)image andKey:(NSString *)key
{

    chosenImage = image;
    
    _avatar.image = chosenImage;
    _avatarReceived = chosenImage;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [_parentView.navigationController setNavigationBarHidden:NO animated:YES];
        _parentView.navigationItem.hidesBackButton = NO;
    }
    
    if([_parentView isKindOfClass:[RacesViewController class]] ||[_parentView isKindOfClass:[RaceListsViewController class]])
    {
        
        for (UIViewController *controller in _parentView.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[RacesViewController class]] || [controller isKindOfClass:[JoinRaceByTopicView class]])
            {
                [_parentView.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
    }
    else
    {
        [_parentView.navigationController popViewControllerAnimated:TRUE];
    }
    
    [self showInView:aPreviousView animated:true];
    
}

- (void)ChoosingAvatar:(UIImage *)image {
    chosenImage = image;
    
    _avatar.image = chosenImage;
    _avatarReceived = chosenImage;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [_parentView.navigationController setNavigationBarHidden:NO animated:YES];
        _parentView.navigationItem.hidesBackButton = NO;
    }
    
    if([_parentView isKindOfClass:[RacesViewController class]] ||[_parentView isKindOfClass:[RaceListsViewController class]])
    {
    
        for (UIViewController *controller in _parentView.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[RacesViewController class]] || [controller isKindOfClass:[JoinRaceByTopicView class]])
            {
                [_parentView.navigationController popToViewController:controller animated:YES];
                
                break;
            }
        }
    }
    else
    {
        [_parentView.navigationController popViewControllerAnimated:TRUE];
    }
    
    [self showInView:aPreviousView animated:true];
    
}

- (void)presentController:(UIViewController *)controller sender:(id)sender
{
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    chosenImage = info[UIImagePickerControllerEditedImage];
    
    if ([_parentView isKindOfClass:[RacesViewController class]] || [_parentView isKindOfClass:[RaceListsViewController class]]) {
        _avatar.image = chosenImage;
        _avatarReceived = chosenImage;
    }
    
    if (SYSTEM_VERSION_LESS_THAN(@"8"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [_parentView.navigationController setNavigationBarHidden:NO animated:YES];
        _parentView.navigationItem.hidesBackButton = NO;
    }
    
    [self dismissController:picker];
}


- (void)photoPickerControllerDidCancel {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
}

@end
