//
//  PostCell.h
//  Bloomer
//
//  Created by Steven on 3/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "out_content_post.h"
#import "SEDraggableLocation.h"
#import "API_ShareFacebook.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FriendsUpdatePopupView.h"

@protocol PostCellDelegate <NSObject>
- (void) deletePostCellWithPostID:(NSString *) postID;
@end

@interface PostCell : UITableViewCell<FBSDKSharingDelegate,FriendsUpdatePopupViewDelegate>

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;
@property (weak, nonatomic) IBOutlet UILabel *labelCaption;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UIView *actionView;
//@property (weak, nonatomic) IBOutlet UIButton *buttonRaceTags;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIButton *buttonShare;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (weak, nonatomic) IBOutlet UIImageView *iconGivedFlowerPhoto;
@property (weak, nonatomic) IBOutlet UIView *flowerView;
@property (weak, nonatomic) IBOutlet UIView *flowerViewMainView;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelUserFlower;
@property (weak, nonatomic) IBOutlet UIImageView *otherAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelOtherName;
@property (weak, nonatomic) IBOutlet UILabel *labelOtherFlower;
@property (weak, nonatomic) IBOutlet UIButton *buttonSponsor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCaptionBottomMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelCaptionTopMargin;

@property (assign, nonatomic) NSInteger indexForEdit;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIViewController *parentViewController;
@property (weak,nonatomic) id<PostCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *buttonComment;

- (IBAction)touchProfileButton:(id)sender;
- (IBAction)touchMoreButton:(id)sender;
- (IBAction)touchSponsorButton:(id)sender;
- (IBAction)touchCommentButton:(id)sender;
- (IBAction)touchShareButton:(id)sender;

- (void)showThankYouView:(BOOL)show;
- (void)bindData:(out_content_post*)data;

@end
