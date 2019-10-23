//
//  UploadAvatarPopUpView.m
//  Bloomer
//
//  Created by Steven on 6/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "UploadAvatarPopUpView.h"
#import "PhotoGalleryViewController.h"
#import "ChangeAvatarViewController.h"
#import "BloomerAlbumViewController.h"
#import <DZNPhotoPickerController/UIImagePickerController+Edit.h>
#import "MyProfileViewController.h"
#import "UserDefaultManager.h"
#import "JoinRaceByTopicView.h"
#import "RaceAlertView.h"
#import "out_profile_fetch.h"
#import "UIView+Extension.h"

@interface UploadAvatarPopUpView()
{
    UserDefaultManager *userDefaultManager;
    BOOL isSubmitting;
}

@property (weak, nonatomic) UIImage *selectedPhoto;
@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (assign, nonatomic) BOOL isSubmitState;

@end

@implementation UploadAvatarPopUpView

+ (id)createInView:(UIView*)view parentView:(UIViewController*)parentView raceKey:(NSString *)raceKey category:(NSInteger)type
{
    UploadAvatarPopUpView *popupView = [[NSBundle mainBundle] loadNibNamed:@"UploadAvatarPopUpView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    popupView.parentView = parentView;
    popupView.raceKey = raceKey;
    popupView.categoryType = type;
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.clipsToBounds = true;
    
    self.contentView.layer.cornerRadius = 12;
    self.contentView.clipsToBounds = true;
    
    self.buttonCancel.layer.cornerRadius = 12;
    self.buttonCancel.clipsToBounds = true;
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    //    if(![userDefaultManager getUserProfileData].isupload_avatar) {
    //        [self.buttonBloomerAlbum setUserInteractionEnabled:NO];
    //        [self.buttonBloomerAlbum setTitleColor:UIColorFromRGB(0xAEAEAE) forState:UIControlStateNormal];
    //    }
}

- (void)submitImageToServer
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    isSubmitting = YES;
    __weak UploadAvatarPopUpView *weakSelf = self;
    
    API_Avatar_Attached *api = [[API_Avatar_Attached alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] image:self.selectedPhoto];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_avatar_attached *data = (out_avatar_attached *)jsonObject;
        if (response.status) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
            
            out_profile_fetch *profileData = [weakSelf.userDefaultManager getUserProfileData];
            profileData.isupload_avatar = true;
            [weakSelf.userDefaultManager saveUserProfileData:profileData];
            
            if (weakSelf.categoryType > RACECATEGORY_LOCATION) {
                [weakSelf invoke_API_JoinRaceWith:data.photo_id];
            } else {
                [weakSelf invoke_API_Avatar_RaceAttached];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }

    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)invoke_API_JoinRaceWith:(NSString *)photoID {
    API_JoinRace *api = [[API_JoinRace alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] key:self.raceKey photoID:photoID];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        isSubmitting = false;
        
        if (response.status) {
            if ([self.parentView isKindOfClass:[RacesViewController class]]) {
                RacesViewController *raceViewController = (RacesViewController *)self.parentView;
                raceViewController.isJoin = RACE_JOINED;
                [raceViewController pullToRefresh];
            }
            
            if ([self.parentView isKindOfClass:[RaceListsViewController class]]) {
                RaceListsViewController *viewController = (RaceListsViewController*)self.parentView;
                [viewController reloadAllRaceLists];
            }
            
            if ([self.parentView isKindOfClass:[JoinRaceByTopicView class]]) {
                [self.parentView.navigationController popToRootViewControllerAnimated:true];
                [NotificationHelper postNotificationForGoingToSpecificRace:[self.userDefaultManager getUserProfileData].gender key:self.raceKey timeStampKey:nil];
            }
            if(self.OnRaceJoined != nil)
                self.OnRaceJoined();
            
            [self removeAnimate];
        } else {
            [AppHelper showMessageBox:@"" message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)invoke_API_Avatar_RaceAttached {
    API_Avatar_RaceAttached *api = [[API_Avatar_RaceAttached alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] image:self.selectedPhoto key:self.raceKey];
    
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        isSubmitting = NO;
        [[userDefaultManager getUserProfileData] setIsupload_avatar:response.status];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if (response.status) {
            if ([self.parentView isKindOfClass:[RacesViewController class]])
            {
                RacesViewController *raceViewController = (RacesViewController*)self.parentView;
                raceViewController.isJoin = RACE_JOINED;
                [raceViewController pullToRefresh];
            }
            
            if ([self.parentView isKindOfClass:[RaceListsViewController class]])
            {
                RaceListsViewController *viewController = (RaceListsViewController*)self.parentView;
                [viewController reloadAllRaceLists];
            }
            
            if ([self.parentView isKindOfClass:[JoinRaceByTopicView class]])
            {
                [self.parentView.navigationController popToRootViewControllerAnimated:true];
                [NotificationHelper postNotificationForGoingToSpecificRace:[self.userDefaultManager getUserProfileData].gender key:self.raceKey timeStampKey:nil];
            }
            
            [self removeAnimate];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)switchToSubmitState
{
    self.isSubmitState = true;
    [self.buttonCancel setTitle:@"Done" forState:UIControlStateNormal];
}

- (void)sendThisViewToBack
{
    [[UIApplication sharedApplication].keyWindow sendSubviewToBack:self];
}

- (void)bringThisViewToFront
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
}

- (void)bringViewToFront:(UIView*)view
{
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];
}

- (void)loadProfileGallery
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_Profile_Gallery_Fetches *api = [[API_Profile_Gallery_Fetches alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] uid:[self.userDefaultManager getUserProfileData].uid];
    
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status)
        {
            BloomerAlbumViewController *viewController = [[BloomerAlbumViewController alloc] initWithNibName:@"BloomerAlbumViewController" bundle:nil];
            viewController.galleryList = [data galleryList];;
            viewController.hidesBottomBarWhenPushed = true;
            viewController.parentView = self.parentView;
            viewController.chosePhoto = ^(UIImage *chosenImage) {
                self.selectedPhoto = chosenImage;
                self.avatar.image = chosenImage;
                [self bringThisViewToFront];
                [self switchToSubmitState];
            };
            viewController.cancelChoosePhoto = ^{
                [self bringThisViewToFront];
            };
            
            [self sendThisViewToBack];
            [self.parentView.navigationController pushViewController:viewController animated:true];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
         [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];

}

// MARK: - Actions

- (IBAction)touchButtonGallery:(id)sender
{
    PhotoGalleryViewController *photoGalleryViewController = [[PhotoGalleryViewController alloc]initWithNibName:@"PhotoGalleryViewController" bundle:nil];
    photoGalleryViewController.hidesBottomBarWhenPushed = true;
    photoGalleryViewController.parentView = self.parentView;
    photoGalleryViewController.isMultipleChoice = false;
    photoGalleryViewController.chosePhoto = ^(UIImage *chosenImage) {
        self.selectedPhoto = chosenImage;
        self.avatar.image = chosenImage;
        [self bringThisViewToFront];
        [self switchToSubmitState];
    };
    photoGalleryViewController.cancelChoosePhoto = ^{
        [self bringThisViewToFront];
    };
    
    [self sendThisViewToBack];
    [self.parentView.navigationController pushViewController:photoGalleryViewController animated:true];
}

- (IBAction)touchButtonTakePhoto:(id)sender
{
    __weak __typeof(self)weakSelf = self;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        // Dismiss when the crop mode was disabled
        if (picker.cropMode == DZNPhotoEditorViewControllerCropModeNone) {
            [self bringThisViewToFront];
            [weakSelf handleImagePicker:picker withMediaInfo:info];
        }
    };
    
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [self bringThisViewToFront];
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self sendThisViewToBack];
    [self.parentView presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)touchButtonBloomerAlbum:(id)sender
{
    [self loadProfileGallery];
}

- (IBAction)touchButtonCancel:(id)sender
{
    if (self.isSubmitState)
    {
        if(!isSubmitting)
            [self submitImageToServer];
    } else {
        [self removeAnimate];
    }
}

- (IBAction)touchBackground:(id)sender
{
    [self removeAnimate];
}

// MARK: - Required Functions
- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.mainViewBottomMargin.constant = 0;
            [self.mainVIew setNeedsLayout];
            
            [UIView animateWithDuration:.4 animations:^{
                [self layoutIfNeeded];
            }];
        }
    }];
}

- (void)removeAnimate
{
    self.mainViewBottomMargin.constant = [UIScreen mainScreen].bounds.size.height * -1;
    [self.mainVIew setNeedsLayout];
    
    [UIView animateWithDuration:.4 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        self.mainViewBottomMargin.constant = [UIScreen mainScreen].bounds.size.height * -1;
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

// MARK: - Delegate
- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    self.selectedPhoto = info[UIImagePickerControllerEditedImage];
    self.avatar.image = self.selectedPhoto;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self switchToSubmitState];
}

- (void)photoPickerControllerDidCancel
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7"))
    {
        [[UIApplication sharedApplication] setStatusBarHidden:FALSE];
    }
}

@end
