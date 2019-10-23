//
//  UploadingPicturesTableViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 10/23/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "UploadingPictureTableViewCell.h"
#import "post_create.h"
#import "API_PostCreate.h"
#import "out_post_create.h"
#import "out_avatar_attached.h"
#import "API_Avatar_Attached.h"
#import "out_avatar_attached.h"
#import "payload.h"
#import "Spinner.h"
#import "API_RaceTagFetch.h"
#import "childs.h"
#import "API_CaptionEdit.h"
#import "API_Post_Delete.h"
#import "UploadPictureMultipleViewCell.h"
#import "PhotoListViewController.h"

@interface UploadingPicturesTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomMargin;
@property (strong, nonatomic) NSMutableArray *uploadPhotos;
@property (strong, nonatomic) NSMutableArray *locationIndex;
@property (weak, nonatomic) UIViewController *parentView;
@property (strong, nonatomic) NSMutableArray *captions;
@property (strong, nonatomic) NSMutableArray *tag;
@property (strong, nonatomic) NSString* name;
// for edit Caption
@property (assign, nonatomic) BOOL isCaptionEditting;
@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) NSString *key;
//@property (weak, nonatomic) UIImage *picture;
@property (weak, nonatomic) IBOutlet UIProgressView *ProgressUploadBar;
@property (weak, nonatomic) IBOutlet UILabel *NameOfRace;

@property (assign, nonatomic) NSInteger indexForEdit;

- (IBAction)handSingleTap:(id)sender;

- (void)removingIndex:(NSInteger)index;


@end
