//
//  MoreLocationViewController.m
//  Bloomer
//
//  Created by Steven on 12/17/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "MoreLocationViewController.h"
#import "NotificationHelper.h"
#import "UISearchBar+Extension.h"

@interface MoreLocationViewController ()
{
    NSMutableArray *searchResult;
    NSString* keyInCell;
}
@end

@implementation MoreLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    searchResult = [[NSMutableArray alloc] init];
    
    [self initNavigationBar];
    [self.searchBar setupSearchBar];
    
    [self.collectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
    [self.searchResultCollectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToReloadRaceList:) name:[NotificationNames NeedToReloadRaceList] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames NeedToReloadRaceList] object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"MoreLocation.title", "")];
}

- (void)searchLocations:(NSString*)searchText
{
    [searchResult removeAllObjects];
    
    for (races_list *race in self.locationRaces)
    {
        if ([race.name containsString:searchText])
        {
            [searchResult addObject:race];
        }
    }
}

// MARK: - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth / 2, [RaceListCell cellHeight]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView)
    {
        return self.locationRaces.count;
    }
    else
    {
        return searchResult.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RaceListCell *cell = (RaceListCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[RaceListCell cellIdentifier] forIndexPath:indexPath];
    cell.labelTimeHeight.constant = 0;
    
    if (indexPath.row % 2) // odd
    {
        cell.mainViewLeftMargin.constant = 2.5;
    }
    else // even
    {
        cell.mainViewRightMargin.constant = 2.5;
    }
    
    races_list *race = (races_list*)[self.locationRaces objectAtIndex:indexPath.row];
    
    if (collectionView == self.searchResultCollectionView)
    {
        race = (races_list*)[searchResult objectAtIndex:indexPath.row];
    }
    
    cell.labelTitle.text = race.name;
    
    if (race.avatar != nil)
    {
        [cell.avatar setImageWithURL:[NSURL URLWithString:race.avatar]];
    }
    else
    {
        cell.avatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if (race.isClosed)
    {
        [cell switchActionView:Closed];
        
        cell.labelTime.text = NSLocalizedString(@"Closed",);
    }
    else
    {
        if (race.is_join == RACE_NOT_ALLOW_TO_JOIN )
        {
            [cell switchActionView:Closed];
        }
        else
        {
            if (race.is_join == RACE_NOT_JOINED)
            {
                if (race.category == RACECATEGORY_LOCATION)
                {
                    [cell switchActionView:Switch];
                }
                else
                {
                    [cell switchActionView:NotJoined];
                }
            }
            else // RACE_JOINED
            {
                [cell switchActionView:Joined];
            }
        }
        
        //        if(temp.category == RACECATEGORY_SPONSOR){
        //            [cell.infoButton setHidden:FALSE];
        //        }
        //        else
        //            [cell.infoButton setHidden:TRUE];
        
        cell.raceData = race;
        
        if (race.category > RACECATEGORY_LOCATION)
        {
            cell.labelTime.text = [NSString stringWithFormat:@"%@", race.endDate];
        }
        else
        {
            cell.labelTime.text = @"";

        }
    }
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    races_list *race = (races_list*)[self.locationRaces objectAtIndex:indexPath.row];
    
    if (collectionView == self.searchResultCollectionView)
    {
        race = (races_list*)[searchResult objectAtIndex:indexPath.row];
    }
    
    if (!race.isClosed)
    {
        RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
        view.key = race.key;
        view.gender = _gender;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:race.closedURL]];
    }
}

// MARK: - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchLocations:searchText];
    [self.searchResultCollectionView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:true animated:true];
    self.searchResultCollectionView.hidden = false;
    
    return true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:true];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:false animated:true];
    self.searchResultCollectionView.hidden = true;
    self.searchBar.text = @"";
    
    return true;
}

// MARK: - Selectors
- (void)needToReloadRaceList:(NSNotification*)notification
{
    [self.collectionView reloadData];
}

@end
