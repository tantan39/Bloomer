//
//  MessagePopupRacesViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "UserProfileViewController.h"

@interface MessagePopupRacesViewController : UIViewController

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)handleSingleTap:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) NSString *number;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (assign, nonatomic) CGFloat distance;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *username;
@property (weak, nonatomic) NSString *numberFlower;
@property (weak, nonatomic) NSString *avatarString;
@property (weak, nonatomic) UIImage *avatarImage;
@property (weak, nonatomic) UINavigationController *MyNavigationController;

@property (assign, nonatomic) BOOL isSurpriseFunc;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *CellView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFlowerLabel;
- (IBAction)ClickCell:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *BubbleBlueMessage;
@property (weak, nonatomic) IBOutlet UIImageView *TriangularBubblePart;
@property (weak, nonatomic) IBOutlet UIImageView *StatusIcon;
@property (weak, nonatomic) IBOutlet UILabel *InfoLabel;
@property (weak, nonatomic) UIViewController* parentView;


@property (assign, nonatomic) NSInteger uid;


@end
