//
//  UserProfileViewController.h
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 3/15/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileRaceListTableViewCell.h"
#import "ProfileAchievementsListTableViewCell.h"
#import "UserProfilePopupViewController.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "Support.h"

#import "FlowerMenuPostPopupViewController.h"
#import "API_Flower_GivePost.h"
#import "API_Flower_GiveProfile.h"
#import "API_Profile_Post_GalleryFetches.h"
#import "gallery.h"
#import "API_ProfileFetch.h"
#import "out_profile_fetch.h"
#import "API_Profile_BannerFetches.h"
#import "API_Profile_Gallery_Fetches.h"
#import "AchievementViewController.h"
#import "BrowserViewController.h"
#import "API_BlockRemove.h"
#import "MembershipViewController.h"
#import "NSString+Extension.h"

@interface UserProfileViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, SEDraggableLocationEventResponder, SEDraggableEventResponder, AwesomeMenuDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) TabBarView *tabbar;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) NSMutableArray* achieveData;
@property (strong, nonatomic) NSMutableArray* activeAchieveData;
@property (strong, nonatomic) NSMutableArray* closedAchieveData;
@property (strong, nonatomic) NSString* post_id;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *swipeToViewMore;
@property (weak, nonatomic) IBOutlet UIScrollView *slideshow;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *avatarCircle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *numberFlower;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *albumsacheivementCollection;
@property (weak, nonatomic) IBOutlet UIButton *currentRankButton;
@property (weak, nonatomic) IBOutlet UIButton *bestResultButton;
@property (weak, nonatomic) IBOutlet UIButton *achievementButton;

@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UILabel *unlockChatContentLabel;
@property (weak, nonatomic) IBOutlet UIView *chatPopupView;
@property (weak, nonatomic) IBOutlet UILabel *numReciever;
@property (weak, nonatomic) IBOutlet UILabel *numGivers;
@property (weak, nonatomic) IBOutlet UILabel *GiverTitle;
@property (weak, nonatomic) IBOutlet UILabel *flowerName;
@property (weak, nonatomic) IBOutlet UILabel *RecieveTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ChatIcon;
@property (weak, nonatomic) IBOutlet UILabel *ChatLabel;

@property (weak, nonatomic) IBOutlet UILabel *blockView;

@property (weak, nonatomic) IBOutlet UIView *TopViewImage;
@property (weak, nonatomic) IBOutlet UIView *FlowerNumView;
@property (weak, nonatomic) IBOutlet UIView *LineView;
@property (weak, nonatomic) IBOutlet UIView *StatusView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopViewContrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomViewContrain;


@property (weak, nonatomic) IBOutlet UILabel *TakePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *Achievementlabel;
@property (weak, nonatomic) IBOutlet UILabel *FlowerShopLabel;
@property (weak, nonatomic) UIViewController* destinationView;

//Winner button
@property (weak, nonatomic) IBOutlet UIButton *winnerButton;
- (IBAction)TouchButtonWinner:(id)sender;

- (IBAction)touchSegmentControl:(id)sender;
- (void)giveFlower:(long long)flower;
- (void)loadProfileUsingAPI;

//BlockBanner
@property (weak, nonatomic) IBOutlet UILabel *BlockLabel;
@property (weak, nonatomic) IBOutlet UIButton *YesButtonBlock;
@property (weak, nonatomic) IBOutlet UIButton *NoButtonBlock;

@property (weak, nonatomic) IBOutlet UIView *LockView;
@property (weak, nonatomic) IBOutlet UIView *BeingLockedView;

//GBS
@property (weak, nonatomic) IBOutlet UIImageView *imageGBS;
@property (weak, nonatomic) IBOutlet UIView *GBSView;



@end

