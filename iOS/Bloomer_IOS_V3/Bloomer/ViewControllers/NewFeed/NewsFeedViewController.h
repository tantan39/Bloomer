//
//  NewFeedViewController.h
//  Bloomer
//
//  Created by Phan Van Thanh Dat on 12/21/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedPageMenu.h"
#import "SearchNewFeedTableViewCell.h"
#import "UISearchBar+Extension.h"
#import "UIColor+Extension.h"
#import "CommunityCollectionViewCell.h"
#import "BloomerNewsCollectionViewCell.h"
#import "NewsFeedSearchCustomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewsFeedViewController : UIViewController <UIScrollViewDelegate, UISearchBarDelegate, UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,NewsFeedPageMenuDelegate>

@property (weak, nonatomic) IBOutlet NewsFeedPageMenu *pageMenuCustomView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

NS_ASSUME_NONNULL_END
