//
//  NotificationViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/18/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Support.h"
#import "API_Notification_Fetch.h"
#import "notification.h"
#import "out_notification_fetch.h"
#import "UserDefaultManager.h"
#import "image_photo.h"
#import "UIImageView+AFNetworking.h"
#import "MKNumberBadgeView.h"
#import "TabBarView.h"
//#import "FullPictureViewController.h"
#import "face.h"
//#import "post_fetch_apost_using.h"
#import "out_post_fetch_apost.h"
#import "post_detail.h"
#import "UIImageView+AFNetworking.h"
#import "NotificationTableViewCell.h"
#import "NSDate+TimeAgo.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ListOfFlowerGiver.h"
#import "AppDelegate.h"
#import "HotNewsPopUpView.h"
#import "API_NotiMarketing.h"
#import "API_DeletePopupNoti.h"
#import "FlowerGiverViewController.h"

@interface NotificationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,NotificationTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (strong, nonatomic) NSMutableArray* notificationData;
@property (strong, nonatomic) image_photo* imagePhotoAPI;
@property (weak, nonatomic) MKNumberBadgeView *badgeNumber;
@property (weak, nonatomic) TabBarView *tabbar;
@property (strong, nonatomic) NSMutableArray *faceData;
@property (weak, nonatomic) IBOutlet UILabel *ContentBonus;

@property (weak, nonatomic) IBOutlet UIView *BonusInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *iconBonus;
@property (weak, nonatomic) IBOutlet UILabel *labelSeeMore;
- (IBAction)OpenShop:(id)sender;

@end
