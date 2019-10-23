//
//  TopWinnerView.h
//  Bloomer
//
//  Created by Steven on 1/3/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Social/Social.h>

#import "TopWinner.h"
#import "TabBarViewController.h"
#import "API_RewardShare.h"
#import "ShareRewardView.h"

@interface TopWinnerView : UIView <FBSDKSharingDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareFlowerLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (copy, nonatomic) void(^didCompleteShareFacebook)();

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIView *parentView;


- (void)bindData:(TopWinner*)data flowers:(NSInteger)flowers;

@end
