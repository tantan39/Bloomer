//
//  MyProfileViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+Utilities.h"
#import "UIImageView+Extension.h"
#import "TabBarView.h"
#import "out_profile_fetch.h"
#import "hImage.h"

#import "SEDraggableLocation.h"
#import "SEDraggable.h"
#import "AwesomeMenu.h"
#import "out_flower_give.h"
#import "flower_give_post.h"

#import "FlowerMenuPopUpViewController.h"
#import "image_photo.h"
#import "ChatViewController.h"
#import "NotificationViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "face.h"
#import "API_FaceUser.h"
#import "out_faces.h"
#import "API_Sponsors_Fetch.h"
#import "sponsors.h"
#import "out_sponsor_fetch.h"
#import "JSON_Achievement.h"
#import "API_RaceFavouriteOne.h"
#import "RaceFavouriteObj.h"
#import "ChatListViewController.h"
#import "RepositionViewController.h"
#import "MKNumberBadgeView.h"
#import "API_Profile_Me.h"
#import "UploadingPicturesViewController.h"
#import "ImagePickerPopUpViewController.h"
#import "out_profile_update.h"

#import "ProfileRaceListTableViewCell.h"

#import "ContactListViewController.h"

#import "profile_gallery.h"
#import "FlowerGiverViewController.h"
#import "API_Profile_Post_GalleryFetches.h"
#import "gallery.h"
#import "achievementObject.h"
#import "FlowerRelationViewController.h"
#import "API_Profile_AvatarsFetches.h"
#import "ChangeStatusPopUpViewController.h"
#import "AchievementViewController.h"

#import "MembershipViewController.h"
#import "NSString+Extension.h"
#import "RemindInviteCode.h"
#import "MyProfileHeaderViewCell.h"
#import "BellNotificationCustomView.h"
#import "PhotosDataSource.h"
#import "PostsDataSouce.h"
#import "AlbumsDataSource.h"
#import "PostDetailVC.h"
#import "PhotoAlbumVC.h"
#import "ChangeProfileViewController.h"
#import "NavigationViewController.h"
#import "UpdateAvatarViewController.h"
#import "UpdateProfileCustomView.h"

typedef enum SectionTypeCell : NSInteger {
    UpdateProfileRemindPopUp,
    ProfileInfo,
    DataCollection,
} SectionTypeCell;

@interface MyProfileViewController : UIViewController < SEDraggableLocationEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UITabBarDelegate,MyProfileHeaderViewCellDelegate,BellNotificationCustomViewDelegate, UpdateProfileCollectionViewCellDelegate>

@property (weak, nonatomic) TabBarView *tabbar;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray * sections; //should be 2 or 3 for show update profile popup

@property (weak, nonatomic) IBOutlet UILabel *numberFlower;

@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *NumRecieve;
@property (weak, nonatomic) IBOutlet UILabel *NumberGived;
@property (weak, nonatomic) IBOutlet UILabel *GiverTitle;
@property (weak, nonatomic) IBOutlet UILabel *flowerName;
@property (weak, nonatomic) IBOutlet UILabel *RecieverTitle;

- (void)pullToRefresh;

@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) NSMutableArray *thumbDraggableLocatioinList;
@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;

@property (strong, nonatomic) AwesomeMenu *circularMenu;

@property (weak, nonatomic) IBOutlet UILabel *chatNotiNumber;

@property (assign, nonatomic) UpdateProfileType updateMode;

@property (weak, nonatomic) NSMutableArray* sponsorData;
@property (weak, nonatomic) NSMutableArray* favouriteData;
@property (strong, nonatomic) NSMutableArray* galleryData;
@property (weak, nonatomic) NSMutableArray* achieveData;
@property (strong, nonatomic) NSMutableArray* activeAchieveData;
@property (strong, nonatomic) NSMutableArray* closedAchieveData;
@property (weak, nonatomic) MKNumberBadgeView* badgeNumber;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (weak, nonatomic) UIViewController *parent;

@property (strong, nonatomic) IBOutlet UILabel *rewardNotiBubble;

// WinnerButton
@property (weak, nonatomic) IBOutlet UIButton *winnerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updatePhoneReminderViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updateAvatarReminderHeightConstraint;
//- (IBAction)touchUpdatePhoneReminderCloseButton:(id)sender;

//- (void)initProfile;
//- (void)loadProfileMeUsingAPI;

- (void)UploadAvatartoLocationRaceWithImage:(UIImage*)image raceKey:(NSString*)key complete:(void (^) (void))complete;
- (void) showRemindInviteCodePopUpWith:(long) inviteFlowerNumb;
- (void)updateNotificationNumber;

@end
