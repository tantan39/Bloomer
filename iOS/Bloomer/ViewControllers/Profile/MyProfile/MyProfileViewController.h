//
//  MyProfileViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/20/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Utilities.h"
#import "UIImageView+Extension.h"
#import "TabBarView.h"
#import "UserDefaultManager.h"
#import "out_profile_fetch.h"
#import "hImage.h"
#import "Spinner.h"
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
#import "UIImageView+AFNetworking.h"
#import "ChatListViewController.h"
#import "RepositionViewController.h"
#import "MKNumberBadgeView.h"
#import "API_Profile_Me.h"
#import "UploadingPicturesViewController.h"
#import "ImagePickerPopUpViewController.h"
#import "out_profile_update.h"
#import "ChoosingBannersViewController.h"
#import "ProfileRaceListTableViewCell.h"
#import "ProfileAchievementsListTableViewCell.h"
#import "ContactListViewController.h"
#import "API_Profile_BannerFetches.h"
#import "BannerObj.h"
#import "profile_gallery.h"
//#import "API_Profile_Gallery_Fetches.h"
#import "FlowerGiverViewController.h"
#import "API_Profile_Post_GalleryFetches.h"
#import "gallery.h"
#import "achievementObject.h"
#import "FlowerRelationViewController.h"
#import "API_Profile_AvatarsFetches.h"
#import "ChangeStatusPopUpViewController.h"
#import "AchievementViewController.h"
#import "UIView+DCAnimationKit.h"
#import "MembershipViewController.h"
#import "NSString+Extension.h"
#import "RemindInviteCode.h"
#import "ChangeBannerViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


@interface MyProfileViewController : UIViewController<himageDelegate, UIScrollViewDelegate, SEDraggableLocationEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, ChangeBannerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIView *avatarCircle;

@property (weak, nonatomic) IBOutlet UILabel *numberFlower;
@property (weak, nonatomic) IBOutlet UILabel *swipeToViewMore;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;
@property (weak, nonatomic) IBOutlet UIButton *achievementButton;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *NumRecieve;
@property (weak, nonatomic) IBOutlet UILabel *NumberGived;
@property (weak, nonatomic) IBOutlet UILabel *GiverTitle;
@property (weak, nonatomic) IBOutlet UILabel *flowerName;
@property (weak, nonatomic) IBOutlet UILabel *RecieverTitle;

- (IBAction)touchUploadButton:(id)sender;
- (IBAction)SegmentedControl:(id)sender;

- (IBAction)touchFollowers:(id)sender;
- (IBAction)touchFollowing:(id)sender;
- (IBAction)touchFlower:(id)sender;

//- (void)AddThankYouView;
//- (void)updateFlowerValue:(long long)num_flower;
- (void)pullToRefresh;

@property (strong, nonatomic) NSMutableArray *images;
//@property (strong, nonatomic) UIImageView *flowerIcon;
@property (strong, nonatomic) NSMutableArray *thumbDraggableLocatioinList;
@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;

@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (weak, nonatomic) IBOutlet UIButton *updateInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet UIButton *currentRankButton;
@property (weak, nonatomic) IBOutlet UIButton *bestResultButton;

- (IBAction)touchCurrentRank:(id)sender;
- (IBAction)touchBestResult:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *iconStatus;
@property (weak, nonatomic) IBOutlet UIImageView *iconTakephoto;
@property (weak, nonatomic) IBOutlet UIImageView *iconChat;
@property (weak, nonatomic) IBOutlet UIImageView *IconAchievement;
@property (weak, nonatomic) IBOutlet UIImageView *IconflowerShop;
@property (weak, nonatomic) IBOutlet UIImageView *IconImageEdit;
@property (weak, nonatomic) IBOutlet UIImageView *iconPlace;
@property (weak, nonatomic) IBOutlet UIImageView *bottomViewImage;

@property (weak, nonatomic) IBOutlet UILabel *chatNotiNumber;
@property (weak, nonatomic) IBOutlet UIView *EditBanner;


@property (assign, nonatomic) BOOL showbottom;
@property (weak, nonatomic) NSMutableArray* sponsorData;
@property (weak, nonatomic) NSMutableArray* favouriteData;
@property (strong, nonatomic) NSMutableArray* galleryData;
@property (weak, nonatomic) NSMutableArray* achieveData;
@property (strong, nonatomic) NSMutableArray* activeAchieveData;
@property (strong, nonatomic) NSMutableArray* closedAchieveData;
@property (weak, nonatomic) MKNumberBadgeView* badgeNumber;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (weak, nonatomic) UIViewController *parent;

@property (weak, nonatomic) IBOutlet UIView *TopViewImage;
@property (weak, nonatomic) IBOutlet UIView *FlowerNumberView;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (weak, nonatomic) IBOutlet UIView *StatusView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;

@property (weak, nonatomic) IBOutlet UILabel *TakePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *ChatLabel;
@property (weak, nonatomic) IBOutlet UILabel *Achievementlabel;
@property (weak, nonatomic) IBOutlet UILabel *FlowerShopLabel;
@property (strong, nonatomic) IBOutlet UILabel *rewardNotiBubble;

// WinnerButton
@property (weak, nonatomic) IBOutlet UIButton *winnerButton;
- (IBAction)TouchInsideWinnerButton:(id)sender;

// Upload avatar reminder
@property (weak, nonatomic) IBOutlet UIView *uploadAvatarReminderView;
@property (weak, nonatomic) IBOutlet UILabel *uploadAvatarReminderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploadAvatarReminderDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *uploadAvatarReminderButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uploadAvatarReminderViewHeight;
- (IBAction)touchUploadAvatarReminderCloseButton:(id)sender;

// Update Phone Reminder
//@property (weak, nonatomic) IBOutlet UIView *updatePhoneReminderView;
//@property (weak, nonatomic) IBOutlet UILabel *updatePhoneReminderTitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *updatePhoneReminderDescriptionLabel;
//@property (weak, nonatomic) IBOutlet UIButton *updatePhoneReminderButton;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *updatePhoneReminderViewHeight;
//- (IBAction)touchUpdatePhoneReminderCloseButton:(id)sender;

// GBS
@property (weak, nonatomic) IBOutlet UIImageView *imageGBS;
@property (weak, nonatomic) IBOutlet UIView *GBSView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WidthContrainBanner;

- (void)loadDataBasedOnButtonIndex:(NSInteger)buttonIndex;
- (void)loadSlideShowUsingAPI;
- (void)initProfile;
- (void)loadProfileMeUsingAPI;
- (void)initNavigationBar;
- (void) loadGallery;
- (void)initAboutMe:(NSString*)string;

@property (weak, nonatomic) IBOutlet UIButton *changeBanner;
- (IBAction)touchChangeBanner:(id)sender;
- (IBAction)TouchAchievement:(id)sender;
- (void)loadAvatars ;
- (void)UploadAvatartoLocationRaceWithImage:(UIImage*)image raceKey:(NSString*)key complete:(void (^) (void))complete;
- (void) showRemindInviteCodePopUpWith:(long) inviteFlowerNumb;
- (void)updateNotificationNumber;
- (void)pullToRefresh;
@end
