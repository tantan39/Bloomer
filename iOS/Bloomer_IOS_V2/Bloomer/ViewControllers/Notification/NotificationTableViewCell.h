//
//  NotificationTableViewCell.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/29/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//


@class NotificationTableViewCell;
#import <UIKit/UIKit.h>
#import "notification.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ShareRewardView.h"
#import "API_RewardShare.h"

@protocol NotificationTableViewCellDelegate <NSObject>
- (void) shareNotificationSuccess:(NSString *) notificationID type:(NotificationType) type;
@end

#import "FullPictureViewController.h"


@interface NotificationTableViewCell : UITableViewCell<UIWebViewDelegate, FBSDKSharingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIImageView *LinkImage;
@property (weak, nonatomic) IBOutlet UIImageView *ChatIcon;
@property (weak, nonatomic) IBOutlet UIButton *AvatarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *ContentButton;
@property (strong, nonatomic) notification * noti;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) UINavigationController *myNavigationController;
@property (weak,nonatomic) id<NotificationTableViewCellDelegate> delegate;
- (IBAction)touchAvatar:(id)sender;
- (IBAction)touchContent:(id)sender;
- (IBAction)touchImage:(id)sender;
- (void)setShareState:(BOOL)enabled;

@end
