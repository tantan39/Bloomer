//
//  DiscoveryTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostUserObj.h"
#import "API_PostUserFetches.h"
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "SEDraggableLocation.h"
#import "DiscoveryViewController.h"
#import "UserProfileViewController.h"
#import "ThankYou.h"

@interface DiscoveryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *receivedFlower;
@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) IBOutlet UIScrollView *slideShow;
@property (strong, nonatomic) NSMutableArray *draggableLocation;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocationTop;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *dragggableLocationScroll;
@property (assign, nonatomic) BOOL done;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) NSMutableArray *postID;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSMutableArray *postList;


- (IBAction)touchAvatar:(id)sender;

- (void)loadPosts;
- (void)initSlideShow;

@end
