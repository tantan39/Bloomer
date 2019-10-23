//
//  ChatListViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "room.h"
#import "API_Rooms_Fetch.h"
#import "out_rooms_fetch.h"
#import "ChatListTableViewCell.h"
#import "image_photo.h"
#import "ChatViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NotificationViewController.h"
#import "NSDate+TimeAgo.h"
#import "API_Profile_FollowerFetches.h"
#import "FlowerGiversListViewController.h"
#import "SWTableViewCell.h"
#import "API_Profile_FollowingFetches.h"
#import "API_ProfileFetch.h"
#import "API_Room_Delete.h"
#import "API_Room_MarkRead.h"

@interface ChatListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate,ChatViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *roomsData;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleGiverView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleReceiverView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCollapseGiverView;
@property (weak, nonatomic) IBOutlet UIButton *buttonCollapseReceiverView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewGiverView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewReceiverView;
@property (weak, nonatomic) IBOutlet UIView *contentViewGiverView;
@property (weak, nonatomic) IBOutlet UIView *contentViewReceiverView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewGiverViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewReceiverWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giverViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverViewHeight;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *giverEmptyView;
@property (weak, nonatomic) IBOutlet UIView *receiverEmptyView;
@property (weak, nonatomic) IBOutlet UIView *messageEmptyView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flowerViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelNoGiver;
@property (weak, nonatomic) IBOutlet UILabel *labelNoReceiver;
@property (weak, nonatomic) IBOutlet UILabel *labelMessages;
@property (weak, nonatomic) IBOutlet UILabel *labelEmptyMessage;

- (IBAction)touchViewAll:(id)sender;
- (IBAction)touchTopGivers:(UIButton*)sender;

- (IBAction)segmentControlValueChanged:(id)sender;
- (IBAction)touchButtonCollapse:(id)sender;

@property (strong, nonatomic) image_photo *imagePhotoAPI;

@end
