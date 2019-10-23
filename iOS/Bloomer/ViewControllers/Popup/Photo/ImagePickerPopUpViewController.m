//
//  ImagePickerPopUpViewController.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 6/15/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "ImagePickerPopUpViewController.h"
#import "MyProfileViewController.h"
#import "ImagePickerRaceViewController.h"
#import <DZNPhotoPickerController/UIImagePickerController+Edit.h>
#import "PhotoGalleryViewController.h"
#import "BloomerAlbumViewController.h"
#import "UserDefaultManager.h"
#import "UploadingPicturesViewController.h"
#import "ChoosingRacesUploadViewController.h"
#import "ChangeAvatarViewController.h"

@interface ImagePickerPopUpViewController ()
{
    UserDefaultManager *userDefaultManager;
    UIImage *chosenImage;
    UIAlertController *alertController;
}
@end

@implementation ImagePickerPopUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        userDefaultManager = [[UserDefaultManager alloc] init];
        
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor clearColor];

    NSString *cancel = NSLocalizedString(@"UpdateAvatar.Cancel", nil);
    NSString *phoneGallery = NSLocalizedString(@"UpdateAvatar.PhoneGallery", nil);
    NSString *takePhoto = NSLocalizedString(@"UpdateAvatar.TakePhoto", nil);
    NSString *bloomerGallery = @"Bloomer Album";
    
    alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self touchBackground:nil];
    }];
    UIAlertAction *phoneGalleryAction = [UIAlertAction actionWithTitle:phoneGallery style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPhotoGallery];
        [self touchBackground:nil];
    }];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:takePhoto style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
        [self touchBackground:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:phoneGalleryAction];
    [alertController addAction:takePhotoAction];
    
    if ([self.parentView isKindOfClass:[ChangeAvatarViewController class]] && [userDefaultManager getUserProfileData].isupload_avatar)
    {
        UIAlertAction *bloomerAlbumAction = [UIAlertAction actionWithTitle:bloomerGallery style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showBloomerAlbum];
            [self removeAnimate];
        }];
        [alertController addAction:bloomerAlbumAction];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if ([self.parentView.navigationController isNavigationBarHidden]) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else {
        if ([self.parentView.navigationController.visibleViewController isKindOfClass:[ChoosingRacesUploadViewController class]] || [self.parentView.navigationController.visibleViewController isKindOfClass:[UpdateInfoViewController class]])
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        }
    }
}

//#pragma mark - Handle Action Sheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    switch (buttonIndex)
//    {
//        case 0: //Open Gallery
//            [self showPhotoGallery];
//            break;
//            
//        case 1: //Open Camera
//            [self openCamera];
//            break;
//            
//        case 2:
//            if ([self.parentView isKindOfClass:[ChangeAvatarViewController class]])
//            {
//                [self showBloomerAlbum];
//            }
//            
//        default:
//            break;
//    }
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
//    [self removeAnimate];
//}

#pragma mark - Show Photo Gallery
- (void) showPhotoGallery
{
    //    if ([_parentView isKindOfClass:[UpdateAvatarSignUpVC class]] || [_parentView isKindOfClass:[ChangeAvatarViewController class]])
    if (self.isUploadAvatar)
    {
        PhotoGalleryViewController *photoGalleryViewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:nil];
        photoGalleryViewController.hidesBottomBarWhenPushed = true;
        photoGalleryViewController.parentView = self.parentView;
        photoGalleryViewController.isMultipleChoice = false;
        
        [self removeAnimate];
        [self.parentView.navigationController pushViewController:photoGalleryViewController animated:true];
    }
    else
    {
        PhotoGalleryViewController *photoGalleryViewController = [[PhotoGalleryViewController alloc] initWithNibName:@"PhotoGalleryViewController" bundle:nil];
        photoGalleryViewController.hidesBottomBarWhenPushed = true;
        photoGalleryViewController.parentView = self.parentView;
        photoGalleryViewController.isMultipleChoice = true;
        photoGalleryViewController.key = self.tag;
        photoGalleryViewController.raceName = self.raceName;
        
        [self removeAnimate];
        [self.parentView.navigationController pushViewController:photoGalleryViewController animated:true];
    }
}

#pragma mark - Open Camera
- (void) openCamera
{
    __weak __typeof(self)weakSelf = self;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
//    if([[self parentView] isKindOfClass:[MyProfileViewController class]] || [self.parentView isKindOfClass:[RacesViewController class]])
    if (!self.isUploadAvatar)
    {
        picker.cropMode = DZNPhotoEditorViewControllerCropModeSquare;
    }
    else
    {
        picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    }
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        // Dismiss when the crop mode was disabled
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [weakSelf handleImagePicker:picker withMediaInfo:info];
        }
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:picker animated:YES completion:NULL];
    [self removeAnimate];
}

- (void)showBloomerAlbum
{
    [self loadGallery];
}

- (void)loadGallery {
    
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Profile_Gallery_Fetches *API = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] uid:[userDefaultManager getUserProfileData].uid];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status) {
            BloomerAlbumViewController *viewController = [[BloomerAlbumViewController alloc] initWithNibName:@"BloomerAlbumViewController" bundle:nil];
            viewController.raceIndex = self.index;
            viewController.galleryList = [data galleryList];
            viewController.hidesBottomBarWhenPushed = true;
            viewController.parentView = self.parentView;
            
            [self removeAnimate];
            [self.parentView.navigationController pushViewController:viewController animated:true];
        } else {
            [Support addErrorMessage:response.message intoView:self.view];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
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
//    if ([_parentView isKindOfClass:[UpdateAvatarSignUpVC class]])
//    {
//        [[_parentView navigationController] setNavigationBarHidden:TRUE animated:YES];
//    }
    [self.view removeFromSuperview];
}

- (IBAction)touchBackground:(id)sender {
    [self removeAnimate];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    __weak ImagePickerPopUpViewController *weakSelf = self;
    chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        if ([_parentView isKindOfClass:[MyProfileViewController class]] )
        {
            ChoosingRacesUploadViewController *viewController = [[ChoosingRacesUploadViewController alloc] initWithNibName:@"ChoosingRacesUploadViewController" bundle:nil];
            viewController.chosenImage = chosenImage;
            viewController.parentView = _parentView;
            viewController.isCamera = true;
            viewController.hidesBottomBarWhenPushed = true;
            [weakSelf.parentView.navigationController pushViewController:viewController animated:TRUE];
        }
        else
        {
            if ([_parentView isKindOfClass:[UpdateInfoViewController class]])
            {
                if ([weakSelf.delegate respondsToSelector:@selector(selectedImageFromImagePicker:)] && chosenImage){
                    [weakSelf.delegate selectedImageFromImagePicker:chosenImage];
                }
            }
            
            if ([_parentView isKindOfClass:[ChangeAvatarViewController class]])
            {
                ChangeAvatarViewController *view = (ChangeAvatarViewController *)_parentView;
                view.isUploadFromBloomer = false;
                [view updateAvatarForRaceByIndex:_index andImage:chosenImage];
            }
            
            if ([_parentView isKindOfClass:[PicturesRaceViewController class]] || [_parentView isKindOfClass:[RacesViewController class]])
            {
                UploadingPicturesTableViewController *view = [[UploadingPicturesTableViewController alloc] init];
                view.uploadPhotos = [[NSMutableArray alloc]initWithObjects:chosenImage, nil];
                view.parentView = _parentView;
                view.tag = [[NSMutableArray alloc]initWithObjects:_tag, nil];;
                view.key = weakSelf.tag;
                view.name = weakSelf.raceName;
                view.hidesBottomBarWhenPushed = true;
                [weakSelf.parentView.navigationController pushViewController:view animated:TRUE];
            }
        }
    }];
}

- (void)photoPickerControllerDidCancel {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
}

@end
