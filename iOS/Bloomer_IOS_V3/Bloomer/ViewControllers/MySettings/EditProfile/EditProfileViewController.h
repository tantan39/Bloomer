//
//  EditProfileViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 4/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UIImageView *avatar1;
@property (weak, nonatomic) IBOutlet UIImageView *avatar2;
@property (weak, nonatomic) IBOutlet UIImageView *avatar3;
@property (weak, nonatomic) IBOutlet UIImageView *avatar4;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *idNameButton;
@property (weak, nonatomic) IBOutlet UILabel *caption;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UIView *uploadAvatarView;
- (IBAction)touchChangeBanner:(id)sender;
- (IBAction)touchChangeAvatar:(id)sender;
- (IBAction)touchChangeName:(id)sender;
- (IBAction)touchChangeUsername:(id)sender;
- (IBAction)touchStatus:(id)sender;
- (IBAction)touchChangeLocation:(id)sender;
- (void)loadProfileMeUsingAPI;
- (void)loadAvatars;
- (void)loadSlideShowUsingAPI;

@end
