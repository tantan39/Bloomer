//
//  MyProfileHeaderViewCell.h
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Extension.h"
#import "AppHelper.h"
#import "UpdateProfileCustomView.h"
#import "out_profile_fetch.h"
#import "NSNumber+Extension.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum PhotosDisplayMode: NSUInteger {
    PHOTOS,
    POSTS,
    ALBUMS,
} PhotosDisplayMode;

@protocol MyProfileHeaderViewCellDelegate<NSObject>
- (void) btnEditAvatar_Pressed;
- (void) btnEditProfile_Pressed;
- (void) btnEditBio_Pressed;
- (void) btnFollowers_Pressed;
- (void) btnFollowing_Pressed;
- (void) btnAchivement_Pressed;
- (void) btnChat_Pressed;

- (void) switchDisplayMode:(NSUInteger) value;
@end

@interface MyProfileHeaderViewCell : UICollectionViewCell<UpdateProfileCustomViewDelegate>
@property (weak,nonatomic) id<MyProfileHeaderViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UpdateProfileCustomView *updatePhoneNumbPopUp;
@property (weak, nonatomic) IBOutlet UpdateProfileCustomView *updateAvatarPopUp;
@property (weak, nonatomic) IBOutlet UILabel *lblFlowersNumb;
@property (weak, nonatomic) IBOutlet UILabel *lblFlowersDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowersDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowingDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblBioDescription;

@property (weak, nonatomic) IBOutlet UIImageView *imgvGSB;
@property (weak, nonatomic) IBOutlet UIButton *btnAchievement;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewDisplayMode;
@property (weak, nonatomic) IBOutlet UIButton *btnPhotoMode;
@property (weak, nonatomic) IBOutlet UIButton *btnPostMode;
@property (weak, nonatomic) IBOutlet UIButton *btnAlbumMode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnEditProfile_PaddingLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgvGSB_WidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *underlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underlineView_PaddingLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updatePhoneReminderViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateAvatarReminderViewHeightConstraint;
@property (assign,nonatomic) BOOL isUpdateInfo;


+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

- (CGFloat) getCellHeight;

- (void) configCell:(out_profile_fetch *) profile;

@end
NS_ASSUME_NONNULL_END
