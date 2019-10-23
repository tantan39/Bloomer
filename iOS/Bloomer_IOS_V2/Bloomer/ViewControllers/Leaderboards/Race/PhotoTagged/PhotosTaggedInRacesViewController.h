//
//  PhotosTaggedInRacesViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosTaggedCollectionViewCell.h"
#import "MenuRacePopupController.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "TabBarView.h"
#import "FlowerMenuPostPopupViewController.h"
#import "UserDefaultManager.h"
#import "API_Races_GalleryFetches.h"
#import "gallery.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "API_Flower_GivePost.h"
#import "out_profile_fetch.h"

@interface PhotosTaggedInRacesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AwesomeMenuDelegate, SEDraggableEventResponder, SEDraggableLocationEventResponder, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *bothGendersButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectedLine;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIScrollView *emptyScrollView;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIImageView *emptyImageView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTextField;

@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) NSString *raceName;
@property (weak, nonatomic) NSString *raceDate;
@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger categoryType;

@property (nonatomic, strong) NSMutableArray *photos;
@property (assign, nonatomic) NSInteger joinState;
@property (assign, nonatomic) long long startTime;
@property (assign, nonatomic) BOOL isComingSoon;

-(void)reloadGallery;

- (void)giveFlower:(long long)flower;

- (IBAction)touchBothGenders:(id)sender;
- (IBAction)touchFemale:(id)sender;
- (IBAction)touchMale:(id)sender;

@end
