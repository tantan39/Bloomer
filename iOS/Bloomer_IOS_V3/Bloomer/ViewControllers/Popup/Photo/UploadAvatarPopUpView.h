//
//  UploadAvatarPopUpView.h
//  Bloomer
//
//  Created by Steven on 6/18/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API_Avatar_Attached.h"
#import "API_Avatar_RaceAttached.h"
#import "API_JoinRace.h"
#import "API_Profile_Gallery_Fetches.h"

@interface UploadAvatarPopUpView : UIView<UIImagePickerControllerDelegate,  UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mainVIew;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelAvatarViewTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonGallery;
@property (weak, nonatomic) IBOutlet UIButton *buttonTakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonBloomerAlbum;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewBottomMargin;

- (IBAction)touchButtonGallery:(id)sender;
- (IBAction)touchButtonTakePhoto:(id)sender;
- (IBAction)touchButtonBloomerAlbum:(id)sender;
- (IBAction)touchButtonCancel:(id)sender;
- (IBAction)touchBackground:(id)sender;

@property (weak, nonatomic) UIView *ownerView;
@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) NSString* raceKey;
@property (assign, nonatomic) NSInteger categoryType;
@property (strong, nonatomic) void (^OnRaceJoined)();

+ (id)createInView:(UIView*)view parentView:(UIViewController*)parentView raceKey:(NSString*)raceKey category:(NSInteger)type;
- (void)showWithAnimated:(BOOL)animated;


@end
