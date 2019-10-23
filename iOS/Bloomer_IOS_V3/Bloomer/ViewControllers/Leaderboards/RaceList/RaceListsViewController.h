//
//  RaceListsViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/26/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "RaceListsTableViewCell.h"
#import "RacesViewController.h"
#import "UserDefaultManager.h"
#import "API_RaceList.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "API_Message_Connect.h"
#import "API_Notification_Pull.h"
#import "API_Message_RefreshToken.h"
#import "MKNumberBadgeView.h"
#import "ConfirmationPopupViewController.h"
#import "API_Profile_Location.h"
#import "RaceListHeaderView.h"
#import "RaceListCell.h"
#import "NotificationHelper.h"
#import "API_PopupMarketing.h"
#import "API_PopupMembership.h"
//#import "join_race_using.h"
#import "WeakLinkObj.h"
#import "SelectCityViewController.h"
#import "API_FlowerGivingPopup.h"


@interface RaceListsViewController : UIViewController < ConfirmationPopupDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, API_NotificationPullDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonMale;
@property (weak, nonatomic) IBOutlet UIButton *buttonFemale;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *femaleCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *maleCollectionView;

- (IBAction)touchButtonFemale:(id)sender;
- (IBAction)touchButtonMale:(id)sender;

@property (weak, nonatomic) TabBarView *tabbar;
@property (strong, nonatomic) API_Notification_Pull *notificationPullAPI;
@property (strong, nonatomic) MKNumberBadgeView *badgeNumber;
@property (strong, nonatomic) MKNumberBadgeView *chatBadgeNumber;
@property (assign, nonatomic) NSUInteger currentPopupIndex;
@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) NSString *raceName;
@property (strong, nonatomic) UIImage *avatarRace;

- (void)reloadAllRaceLists;
- (void)initPullNotification;
@end
