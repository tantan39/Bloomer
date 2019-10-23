//
//  FullPictureViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 3/16/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FriendsUpdatePopupView.h"
#import "face.h"
#import "TabBarView.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"
#import "FlowerMenuPostPopupViewController.h"
#import "AwesomeMenu.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "NotificationViewController.h"
#import "UserProfileViewController.h"
#import "CommentTableViewCell.h"
#import "comment.h"
#import "image_photo.h"
#import "UIImageView+AFNetworking.h"
//#import "API_PostComment_Fetch.h"
#import "out_post_comment_fetch.h"
#import "FullScreensViewController.h"
#import "CommentViewController.h"
#import "MKNumberBadgeView.h"
#import "UIScrollView+SVPullToRefresh.h"
//#import "post_fetch_apost_using.h"
#import "out_flower_give.h"
#import "flower_give_post.h"
#import "API_Flower_GivePost.h"
//#import "API_FaceUser.h"
#import "out_faces.h"
#import "PhotosTaggedInRacesViewController.h"
#import "API_Content_Post_Fetches.h"
#import "FlowerGiverViewController.h"
#import "flower_give_post.h"
#import "API_Follow.h"
#import "ThankYou.h"
#import "API_ShareFacebook.h"
#import "API_ProfileFetch.h"
#import "NumberGiveFlowerPopUp.h"


@interface FullPictureViewController : UIViewController<UIGestureRecognizerDelegate, SEDraggableLocationEventResponder, SEDraggableEventResponder, AwesomeMenuDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UIAlertViewDelegate, FBSDKSharingDelegate,FriendsUpdatePopupViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *pictureScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;
@property (weak, nonatomic) IBOutlet UILabel *labelCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UIButton *buttonViewComments;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *buttonRaceTags;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;

@property (weak, nonatomic) IBOutlet UIImageView *iconGivedFlowerPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonSponsor;
@property (strong,nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSMutableArray *faceData;
@property (strong, nonatomic) NSMutableArray *galleryData;
@property (assign, nonatomic) NSInteger currentIndex;
@property (weak, nonatomic) UIImage *loadedPicture;
@property (weak, nonatomic) NSString *post_id;
@property (strong, nonatomic) NSMutableArray *commentData;
@property (weak, nonatomic) NSMutableArray *sponsorData;

@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (strong, nonatomic) ThankYou *thankyou;
@property (strong, nonatomic) UIImageView *flowerIcon;
@property (weak, nonatomic) TabBarView *tabbar;
@property (assign, nonatomic) BOOL isMain;
@property (assign, nonatomic) BOOL isScrollingEnabled;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) image_photo *imagePhotoAPI;
@property (weak, nonatomic) MKNumberBadgeView *badgeNumber;
@property (strong, nonatomic) NSString *profileID;

@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *BlockedView;
@property (weak, nonatomic) IBOutlet UILabel *ContentBlockedView;
@property (weak, nonatomic) IBOutlet UIImageView *StickerSadImage;
@property (weak, nonatomic) NSString *raceName;
@property (strong,nonatomic) out_content_post * content_post;

- (IBAction)touchAvatarButton:(id)sender;
- (IBAction)touchCommentButton:(id)sender;
- (IBAction)touchViewAllCommentsButton:(id)sender;
- (IBAction)touchRace:(id)sender;
- (IBAction)touchReport:(id)sender;
- (IBAction)touchFlower:(id)sender;
- (IBAction)touchShareButton:(id)sender;


- (void)AddThankYouView;
- (void)reloadComments;
- (void)initCaptionViewWithContent:(NSString*)content;
- (void)initPhotoScrollView;
- (void)initScrollView;
- (void)loadContentPost;
- (void)loadContentPost:(NSString*) postID;
- (void)giveFlowerPost:(long long)flower;
- (void)touchUnFollow;

@end
