//
//  MoreLocationViewController.h
//  Bloomer
//
//  Created by Steven on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RaceListCell.h"
#import "races_list.h"
#import "RacesViewController.h"
#import "ConfirmationPopupViewController.h"
#import "JoinInfoPopupViewController.h"
//#import "API_Profile_Location.h"

@interface MoreLocationViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *searchResultCollectionView;
@property (weak, nonatomic) UINavigationController *myNavigationController;

@property (weak, nonatomic) NSMutableArray *locationRaces;
@property (assign, nonatomic) NSInteger gender;

@end
