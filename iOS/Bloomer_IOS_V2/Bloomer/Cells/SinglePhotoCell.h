//
//  SinglePhotoCell.h
//  Bloomer
//
//  Created by Steven on 12/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEDraggableLocation.h"
#import "UserDefaultManager.h"
#import "TabBarView.h"
#import "FullPictureViewController.h"
#import "UserProfileViewController.h"

@interface SinglePhotoCell : UITableViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *topDraggableLocation;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelFlowerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTimeWidth;
@property (weak, nonatomic) IBOutlet UIImageView *iconGivedFlowerPhoto;
@property (weak, nonatomic) IBOutlet UIView *thankYouView;
@property (weak, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (weak, nonatomic) IBOutlet UIView *profileThankYouView;
@property (weak, nonatomic) IBOutlet UIImageView *profileThankYouIcon;
@property (weak, nonatomic) IBOutlet UILabel *profileThankYouLabel;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UITableView *parentTableView;
@property (weak, nonatomic) NSIndexPath *cellIndex;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) NSString *post_id;
@property (weak, nonatomic) NSString *post_url;
@property (assign, nonatomic) NSInteger photoLoadTime;

- (IBAction)touchAvatarButton:(id)sender;

- (void)setPhotoWithImage:(UIImage*)image;

@end
