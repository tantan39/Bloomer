//
//  FriendsUpdatePopupView.h
//  Bloomer
//
//  Created by Steven on 1/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

@class FriendsUpdatePopupView;
#import <UIKit/UIKit.h>

@protocol FriendsUpdatePopupViewDelegate <NSObject>

- (void) touchDeletePostWith:(NSString *) postID;

@end

#import "UserDefaultManager.h"
#import "SelectionReasonReportViewController.h"
#import "FullPictureViewController.h"

#import "API_CaptionEdit.h"
#import "API_Post_Delete.h"

@interface FriendsUpdatePopupView : UIView <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIView *userPopupView;
//@property (weak, nonatomic) IBOutlet UIView *labelReport;
//@property (weak, nonatomic) IBOutlet UIButton *stopSeeingContentButton;
@property (weak, nonatomic) IBOutlet UIView *followUserPopupView;
@property (weak, nonatomic) IBOutlet UIView *labelFollowView;
@property (weak, nonatomic) IBOutlet UIButton *unfollowButton;
//@property (weak, nonatomic) IBOutlet UIView *unFollowView;
@property (weak, nonatomic) IBOutlet UIView *unFollowBGView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupViewTopMargin;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stopSeeingPopupViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoPopupViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onePhotoPopupViewTopMargin;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonSavePictureList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonReportPictureList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonDeletePictureList;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonEditContentList;

@property (assign, nonatomic) NSInteger indexForEdit;

@property (weak, nonatomic) UIViewController *parentView;
@property (weak, nonatomic) UIView *ownerView;
@property (weak, nonatomic) UIImage *picture;
@property (weak, nonatomic) NSString *caption;
@property (assign, nonatomic) BOOL isMe;
@property (assign, nonatomic) BOOL isNewFeeds;
@property (assign, nonatomic) BOOL following;
@property (assign, nonatomic) CGFloat distance;
@property (weak, nonatomic) NSString *post_id;
@property (assign, nonatomic) BOOL isAvatar;
@property (weak,nonatomic) id<FriendsUpdatePopupViewDelegate> delegate;

- (IBAction)touchStopSeeing:(id)sender;
- (IBAction)touchReport:(id)sender;
- (IBAction)touchEdit:(id)sender;
- (IBAction)touchDelete:(id)sender;
- (IBAction)touchSavePictureToDevice:(id)sende;

+ (id)createInView:(UIView*)view;
- (void)showWithAnimated:(BOOL)animated;
- (void)movePopupToTheRightPosition;

@end
