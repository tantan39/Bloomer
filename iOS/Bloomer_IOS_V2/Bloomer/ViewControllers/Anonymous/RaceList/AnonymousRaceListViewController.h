//
//  AnonymousRaceListViewController.h
//  Bloomer
//
//  Created by Steven on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "RaceListsTableViewCell.h"
#import "RacesViewController.h"
#import "UserDefaultManager.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "MKNumberBadgeView.h"
#import "ConfirmationPopupViewController.h"
#import "RaceListHeaderView.h"
#import "RaceListCell.h"
#import "NotificationHelper.h"

@interface AnonymousRaceListViewController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonMale;
@property (weak, nonatomic) IBOutlet UIButton *buttonFemale;
@property (weak, nonatomic) IBOutlet UIView *animatedLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animatedLineLeftMargin;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *femaleCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *maleCollectionView;
    
- (IBAction)touchButtonFemale:(id)sender;
- (IBAction)touchButtonMale:(id)sender;
    
@property (weak, nonatomic) TabBarView *tabbar;
@property (weak, nonatomic) NSString *key;
@property (weak, nonatomic) NSString *raceName;
@property (strong, nonatomic) UIImage *avatarRace;
- (void)reloadAllRaceLists;
    
@end
