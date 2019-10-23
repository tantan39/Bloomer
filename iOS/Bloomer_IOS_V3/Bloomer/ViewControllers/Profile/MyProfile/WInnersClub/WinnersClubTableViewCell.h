//
//  RacesTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/27/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEDraggableLocation.h"
#import "Support.h"

@interface WinnersClubTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *iconStatus;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UILabel *numFlower;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblFlowerText;
@property (weak, nonatomic) IBOutlet UIButton *TopRankButton;
@property (weak, nonatomic) IBOutlet UIImageView *TopRankImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRankImageTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIView *avatarBorderView;
@property (weak, nonatomic) IBOutlet UIView *avatarRoundView;
@property (weak, nonatomic) IBOutlet UIView *avatarSquareView;
@property (weak, nonatomic) IBOutlet UIImageView *cupImageView;
@property (weak, nonatomic) IBOutlet UIView *cupUIview;

@property (weak, nonatomic) NSString *avatarString;
@property (weak, nonatomic) UINavigationController *MyNavigationController;
@property (weak, nonatomic) UIViewController* parentView;
@property (strong, nonatomic) NSIndexPath *cellIndex;
@property (weak, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) NSString *message;
@property (strong, nonatomic) NSString* link;

+ (NSString *)cellIdentifier;

- (IBAction)ButtonForTopRank:(id)sender;
- (IBAction)touchMessage:(id)sender;

- (void) showUpBubbleView:(BOOL) isHide;
- (void)setVideoLink:(NSString*)link;
- (void)switchStyleForAvatarBorderViewWithMedal:(NSString*)medal isIcon:(BOOL)isIcon;

@end
