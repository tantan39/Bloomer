//
//  ProfileRaceListTableViewCell.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicturesRaceViewController.h"
#import "UserDefaultManager.h"

@interface ProfileRaceListTableViewCell : UITableViewCell

@property (weak, nonatomic) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UILabel *raceName;
- (IBAction)touchViewAll:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *viewAllButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo1;
@property (weak, nonatomic) IBOutlet UIView *photo1View;
@property (weak, nonatomic) IBOutlet UIImageView *photo2;
@property (weak, nonatomic) IBOutlet UIView *photo2View;
@property (weak, nonatomic) IBOutlet UIImageView *photo3;
@property (weak, nonatomic) IBOutlet UIView *photo3View;
@property (weak, nonatomic) IBOutlet UIImageView *LoadMoreImage;
@property (weak, nonatomic) IBOutlet UIView *clickMoreView;
@property (weak, nonatomic) IBOutlet UIImageView *BlockIcon;
@property (weak, nonatomic) IBOutlet UILabel *loadMoreLabel;
@property (weak, nonatomic) IBOutlet UIView *noPhotoView;
@property (strong, nonatomic) IBOutlet UILabel *labelNoPhoto;

@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation;
@property (weak, nonatomic) IBOutlet SEDraggableLocation *draggableLocation1;

@property (strong, nonatomic) NSString* postID;
@property (strong, nonatomic) NSString* postID1;

@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) BOOL done;
@property (strong, nonatomic) ThankYou* thankyouView;
@property (strong, nonatomic) ThankYou* thankyouView1;

//@property (weak, nonatomic) NSString *raceNames;
- (void)loadPhotosByArray:(NSMutableArray*) photos;
- (void)loadPhotoByIndex:(NSInteger)index photoURL:(NSString*)photoURL postID:(NSString *) postId;
- (void) showThankYou:(BOOL)isShow atIndex:(int) index;

+ (NSString *)cellIdentifier;

@end
