//
//  CommentViewController.h
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/28/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "UIImageView+AFNetworking.h"
#import "face.h"
#import "API_PostComment_Fetch.h"
#import "comment.h"
#import "out_post_comment_fetch.h"
#import "API_Post_Comment_Delete.h"
#import "CommentTableViewCell.h"
#import "image_photo.h"
#import "Spinner.h"
#import "TabBarView.h"
#import "post_comment.h"
#import "API_PostComment.h"
#import "out_post_comment.h"
#import "MKNumberBadgeView.h"

@interface CommentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewBottomMargin;
@property (weak, nonatomic) IBOutlet UIView *loadMoreView;
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;

@property (weak, nonatomic) face* captionData;
@property (weak, nonatomic) UIViewController *parentView;
@property (strong, nonatomic) NSMutableArray* commentData;
@property (strong, nonatomic) image_photo* imagePhotoAPI;
@property (weak, nonatomic) TabBarView* tabbar;
@property (weak, nonatomic) MKNumberBadgeView *badgeNumber;
@property (strong, nonatomic) NSString *post_id;
@property (assign, nonatomic) NSInteger post_UserID;
@property (weak, nonatomic) NSString *displayName;
@property (weak, nonatomic) NSString *postCaption;
@property (assign, atomic) BOOL isLoading;

- (IBAction)touchDoneButton:(id)sender;
- (IBAction)handleTapOnTableView:(id)sender;

@end
