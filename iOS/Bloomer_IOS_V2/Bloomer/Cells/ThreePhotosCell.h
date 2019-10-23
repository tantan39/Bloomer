//
//  ThreePhotosCell.h
//  Bloomer
//
//  Created by Steven on 12/11/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEDraggableLocation.h"
#import "UserDefaultManager.h"
#import "TabBarView.h"
#import "FullPictureViewController.h"
#import "UserProfileViewController.h"
#import "PostContent.h"

@interface ThreePhotosCell : UITableViewCell

// MARK: - Static variables
+ (CGFloat) cellHeight;
+ (NSString*) cellIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelFlower;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *topDraggableLocation;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutletCollection(SEDraggableLocation) NSArray *draggableLocations;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pictureViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *photos;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *iconGivedFlowerPhotos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelFlowerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTimeWidth;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray<UIView*> *thankYouViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray<UILabel*> *thankYouLabels;
@property (weak, nonatomic) IBOutlet UIView *profileThankYouView;
@property (weak, nonatomic) IBOutlet UIImageView *profileThankYouIcon;
@property (weak, nonatomic) IBOutlet UILabel *profileThankYouLabel;

@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UITableView *parentTableView;
@property (weak, nonatomic) NSIndexPath *cellIndex;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) TabBarView *tabbar;
@property (strong, nonatomic) NSArray *feedPics;
@property (assign, nonatomic) NSInteger photoLoadTime;
@property (strong, nonatomic) NSString *feedID;

- (IBAction)touchAvatarButton:(id)sender;

- (void)setLastPhotoWithImage:(UIImage*)image;

@end
