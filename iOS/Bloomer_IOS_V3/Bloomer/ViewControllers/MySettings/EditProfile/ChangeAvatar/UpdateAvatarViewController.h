//
//  ChangeAvatarV3ViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 11/29/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "AvatarCollectionViewCell.h"
#import "payload.h"
#import "API_Avatar_RaceAttached.h"
#import "avatar.h"
#import "UIImageView+AFNetworking.h"
#import "API_Avatar_Attached.h"
#import "API_Profile_Gallery_Fetches.h"
#import "UploadingPicturesViewController.h"
#import "ChoosingRacesUploadViewController.h"
#import "ChangeAvatarViewController.h"
#import "MyProfileViewController.h"
#import "ImagePickerRaceViewController.h"
#import <DZNPhotoPickerController/UIImagePickerController+Edit.h>
#import "PhotoGalleryViewController.h"
#import "BloomerAlbumViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface UpdateAvatarViewController : UIViewController <iCarouselDataSource, iCarouselDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (assign, nonatomic) BOOL isUploadFromBloomer;
@property (strong, nonatomic) NSString* curRaceKey;
@property (strong, nonatomic) NSMutableArray *avatarList;
@property (strong, nonatomic) IBOutlet UIButton *albumBloomerBtn;
@property (strong, nonatomic) IBOutlet UIButton *cameraBtn;
@property (strong, nonatomic) IBOutlet UIButton *galleryBtn;

- (IBAction)touchCamera:(id)sender;
- (IBAction)touchGallery:(id)sender;
- (IBAction)touchAlbumBloomer:(id)sender;
-  (void) updateAvatarForRaceByIndex:(NSInteger)index andImage:(UIImage*) chosenImg;

@end

NS_ASSUME_NONNULL_END
