//
//  PicturesRaceViewController.h
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/24/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosTaggedCollectionViewCell.h"
#import "profile_gallery.h"
#import "API_Profile_Post_GalleryFetches.h"
#import "UserDefaultManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "SEDraggable.h"
#import "SEDraggableLocation.h"
#import "AwesomeMenu.h"
#import "API_Flower_GivePost.h"
#import "FlowerMenuPostPopupViewController.h"
#import "out_profile_fetch.h"
#import "API_Content_Post_Fetches.h"

@interface PicturesRaceViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,  AwesomeMenuDelegate, SEDraggableEventResponder, SEDraggableLocationEventResponder>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CollectionViewTopContraint;
@property (weak, nonatomic) IBOutlet UILabel *titleForCloseLeaderBoard;
@property (weak, nonatomic) IBOutlet UIView *topInfoCloseView;
@property (weak, nonatomic) UIViewController *parentMeView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (strong, nonatomic) NSMutableArray *postsData;
@property (strong, nonatomic) NSString *key;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger uid;
@property (weak, nonatomic) NSString *raceName;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (weak, nonatomic) TabBarView *tabbar;
@property (strong, nonatomic) NSMutableArray *listDraggableLocatioinList;

- (void)pullToRefresh;
- (void)giveFlowerPost:(long long)flower;
- (void) deletePhotoAtIndex:(NSInteger) index;
@end
