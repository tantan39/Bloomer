//
//  ImagePickerRaceViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/29/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "TabBarView.h"
#import "TWPhotoPickerController.h"
#import "UploadingPicturesViewController.h"
#import "MKNumberBadgeView.h"
#import "API_Avatar_Attached.h"
#import "API_JoinRace.h"
#import "JoinRaceByTopicView.h"
#import "RaceListsViewController.h"
//#import "profile_gallery_fetches_using.h"

@interface ImagePickerRaceViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, TWPhotoPickerDelegate>

@property (weak, nonatomic) MKNumberBadgeView* badgeNumber;
@property (weak, nonatomic) UIViewController *parentView;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *galleryButton;
@property (weak, nonatomic) IBOutlet UIButton *BloomerAlbumButton;
- (IBAction)touchCamera:(id)sender;
- (IBAction)touchGallery:(id)sender;
- (IBAction)touchDone:(id)sender;
- (IBAction)TouchAlbum:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *uploadFrom;
@property (weak, nonatomic) UIImage *avatarReceived;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger categoryType;
@property (weak, nonatomic) NSString *raceName;
@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *uploadView;
@property (nonatomic, strong) UIImage *selectedPhoto;

@property (weak, nonatomic) UINavigationController *myNavigationController;

@end
