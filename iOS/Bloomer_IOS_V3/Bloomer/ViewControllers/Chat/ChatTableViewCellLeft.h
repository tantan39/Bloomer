//
//  ChatTableViewCellLeft.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 4/1/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEDraggableLocation.h"
#import "UserProfileViewController.h"

@interface ChatTableViewCellLeft : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIView *bubbleView;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgvEmoji;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) NSInteger userID;

@property (strong,nonatomic) message * message;
@property (strong,nonatomic) NSMutableDictionary * stickerList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTimePaddingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgvAvatarPaddingTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgvEmojiPaddingTopConstraint;

- (void) configCellWithMessage:(message *) message Avatar:(UIImage *) avatar StickerList:(NSMutableDictionary *) stickers;

@end
