//
//  FlowerRelationViewController.m
//  Bloomer
//
//  Created by Steven on 3/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FlowerRelationViewController.h"
#import "UIColor+Extension.h"
#import "UserDefaultManager.h"
#import "FlowerRelationCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+TimeAgo.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UserProfileViewController.h"
#import "AppHelper.h"
#import "UISearchBar+Extension.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreSpotlight/CoreSpotlight.h>

#define LIMIT_FETCH 10

@interface FlowerRelationViewController () {
    Spinner *spinner;
}

@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) NSMutableArray *listByRecently;
@property (strong, nonatomic) NSMutableArray *listByFlower;
@property (strong, nonatomic) NSMutableArray *searchResultList;
@property (assign, nonatomic) BOOL loadMore;

@end

@implementation FlowerRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [self.userDefaultManager getUserProfileData];
    self.listByRecently = [[NSMutableArray alloc] init];
    self.listByFlower = [[NSMutableArray alloc] init];
    self.loadMore = false;
    
    [self initNavigationBar];
    
    self.segmentControl.layer.cornerRadius = self.segmentControl.frame.size.height / 2;
    self.segmentControl.layer.borderWidth = 1.5;
    self.segmentControl.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
    self.segmentControl.clipsToBounds = true;
    
    [self.tableView registerNib:[UINib nibWithNibName:[FlowerRelationCell nibName] bundle:nil] forCellReuseIdentifier:[FlowerRelationCell cellIdentifier]];
    [self.searchResultTableView registerNib:[UINib nibWithNibName:[FlowerRelationCell nibName] bundle:nil] forCellReuseIdentifier:[FlowerRelationCell cellIdentifier]];

    self.segmentControl.selectedSegmentIndex = self.tabIndex;
    
    [self.searchBar setupSearchBar];
    [self.searchBar customizeDefaultRoundSearchBar];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSInteger lastUID = -1;
        self.loadMore = true;
        
        if (self.isFollower)
        {
            if (self.segmentControl.selectedSegmentIndex == 0)
            {
                if (self.listByRecently.count > 0)
                {
                    follower *data = (follower*)[self.listByRecently lastObject];
                    lastUID = data.uid;
                }
                
                [self loadFollowers:lastUID sortType:@"time"];
            }
            else
            {
                if (self.listByFlower.count > 0)
                {
                    follower *data = (follower*)[self.listByFlower lastObject];
                    lastUID = data.uid;
                }
                
                [self loadFollowers:lastUID sortType:@"flower"];
            }
        }
        else
        {
            if (self.segmentControl.selectedSegmentIndex == 0)
            {
                if (self.listByRecently.count > 0)
                {
                    follower *data = (follower*)[self.listByRecently lastObject];
                    lastUID = data.uid;
                }
                
                [self loadFollowings:lastUID sortType:@"time"];
            }
            else
            {
                if (self.listByFlower.count > 0)
                {
                    follower *data = (follower*)[self.listByFlower lastObject];
                    lastUID = data.uid;
                }
                
                [self loadFollowings:lastUID sortType:@"flower"];
            }
        }
    }];
    
    if (self.isFollower)
    {
        if (self.tabIndex == 0)
        {
            [self loadFollowers:-1 sortType:@"time"];
        }
        else
        {
            [self loadFollowers:-1 sortType:@"flower"];
        }
    }
    else
    {
        if (self.tabIndex == 0)
        {
            [self loadFollowings:-1 sortType:@"time"];
        }
        else
        {
            [self loadFollowings:-1 sortType:@"flower"];
        }
    }
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupLanguage
{
    [self.segmentControl setTitle:[AppHelper getLocalizedString:@"FlowerRelation.tabRecently"] forSegmentAtIndex:0];
    [self.segmentControl setTitle:[AppHelper getLocalizedString:@"FlowerRelation.tabByFlowers"] forSegmentAtIndex:1];
    self.searchBar.placeholder = [AppHelper getLocalizedString:@"FlowerRelation.search"];
    self.labelNoResult.text = [AppHelper getLocalizedString:@"FlowerRelation.labelNoResult"];
}

- (void)initNavigationBar
{
    if (self.isFollower)
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:[AppHelper getLocalizedString:@"FlowerRelation.givers"]];
    }
    else
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:[AppHelper getLocalizedString:@"FlowerRelation.receivers"]];
    }
}

- (void)searchText:(NSString*)text
{
    if (self.isFollower)
    {
        API_Profile_FollowerSearch *api = [[API_Profile_FollowerSearch alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] term_search:text];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_follower_search * data = (out_follower_search *) jsonObject;
            if (response.status)
            {
                self.searchResultList = data.followerList;
                [self.searchResultTableView reloadData];
                
                if (self.searchResultList.count == 0)
                {
                    self.labelNoResult.hidden = false;
                }
                else
                {
                    self.labelNoResult.hidden = true;
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
        
    }
    else
    {
        API_Profile_FollowingSearch *api = [[API_Profile_FollowingSearch alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] termSearch:text];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_following_search * data = (out_following_search *) jsonObject;
            if (response.status)
            {
                self.searchResultList = data.followingList;
                [self.searchResultTableView reloadData];
                
                if (self.searchResultList.count == 0)
                {
                    self.labelNoResult.hidden = false;
                }
                else
                {
                    self.labelNoResult.hidden = true;
                }
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
        
    }
}

- (void)loadFollowers:(NSInteger)uid sortType:(NSString*)sortType
{
    [spinner startAnimating];
    API_Profile_FollowerFetches *api = [[API_Profile_FollowerFetches alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] uid:uid limit:LIMIT_FETCH sort:sortType];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [spinner stopAnimating];
        out_follower_fetches * data = (out_follower_fetches *) jsonObject;
        if (response.status)
        {
            if (SYSTEM_VERSION_GREATER_THAN(@"8"))
            {
                [self indexSpotlightSearch:data.followerList];
            }
            
            if (self.segmentControl.selectedSegmentIndex == 0)
            {
                if (self.loadMore)
                {
                    [self.listByRecently addObjectsFromArray:data.followerList];
                    self.loadMore = false;
                    [self.tableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByRecently = data.followerList;
                }
            }
            else
            {
                if (self.loadMore)
                {
                    [self.listByFlower addObjectsFromArray:data.followerList];
                    self.loadMore = false;
                    [self.tableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByFlower = data.followerList;
                }
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
    
}

- (void)loadFollowings:(NSInteger)uid sortType:(NSString*)sortType
{
    [spinner startAnimating];
    API_Profile_FollowingFetches *api = [[API_Profile_FollowingFetches alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] uid:uid limit:LIMIT_FETCH sort:sortType];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [spinner stopAnimating];
        out_following_fetches * data = (out_following_fetches *) jsonObject;
        if (response.status)
        {
            if (SYSTEM_VERSION_GREATER_THAN(@"8"))
            {
                [self indexSpotlightSearch:data.followingList];
            }
            
            if (self.segmentControl.selectedSegmentIndex == 0)
            {
                if (self.loadMore)
                {
                    [self.listByRecently addObjectsFromArray:data.followingList];
                    self.loadMore = false;
                    [self.tableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByRecently = data.followingList;
                }
            }
            else
            {
                if (self.loadMore)
                {
                    [self.listByFlower addObjectsFromArray:data.followingList];
                    self.loadMore = false;
                    [self.tableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByFlower = data.followingList;
                }
            }
            
            [self.tableView reloadData];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];

}

- (void)indexSpotlightSearch:(NSMutableArray*)needToIndexList
{
    NSMutableArray *needIndexItems = [[NSMutableArray alloc] init];
    
    for (follower *item in needToIndexList)
    {
        [needIndexItems addObject:item.searchableItem];
//        NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:kSpotlightSearchLeaderboard];
//        [userActivity setEligibleForSearch:true];
//        [userActivity setEligibleForHandoff:true];
//        [userActivity setEligibleForPublicIndexing:true];
//        userActivity.title = [NSString stringWithFormat:@"Bloomer_User_%ld", item.uid];
//        userActivity.userInfo = @{k_UID: [NSNumber numberWithInteger:item.uid]};
//        userActivity.contentAttributeSet = [item searchableItemAttributeSet];
//
//        self.userActivity = userActivity;
//        [self.userActivity becomeCurrent];
    }
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:needIndexItems completionHandler:^(NSError * _Nullable error) {
    }];
}

// MARK: - UITableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        if (self.segmentControl.selectedSegmentIndex == 0)
        {
            return self.listByRecently.count;
        }
        else
        {
            return self.listByFlower.count;
        }
    }
    else
    {
        return self.searchResultList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FlowerRelationCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FlowerRelationCell *cell = [tableView dequeueReusableCellWithIdentifier:[FlowerRelationCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    follower *data = [[follower alloc] init];

    if (tableView == self.tableView)
    {
        
        if (self.segmentControl.selectedSegmentIndex == 0)
        {
            if (self.listByRecently.count > 0) {
                data = (follower*)[self.listByRecently objectAtIndex:indexPath.row];
            }
            
        }
        else
        {
            if (self.listByFlower.count > 0) {
                data = (follower*)[self.listByFlower objectAtIndex:indexPath.row];
            }
            
        }
    }
    else
    {
        data = (follower*)[self.searchResultList objectAtIndex:indexPath.row];
    }
    
    cell.navigationController = self.navigationController;
    cell.data = data;
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
    cell.labelName.text = data.name;
    cell.labelUsername.text = data.username;
    cell.labelFlower.text = @(data.flower).stringValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.timestamp];
    cell.labelTime.text = [date timeAgo];
    
//    if (data.is_chat)
//    {
//        cell.buttonChat.hidden = false;
//    }
//    else
//    {
//        cell.buttonChat.hidden = true;
//    }
    
    if (self.isFollower)
    {
        cell.buttonFollowWidth.constant = 0;
    }
    else
    {
        cell.buttonFollowWidth.constant = 80;
        [cell switchStateForButtonFollow:data.is_follow];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    follower *data = [[follower alloc] init];
    
    if (tableView == self.tableView)
    {
        if (self.segmentControl.selectedSegmentIndex == 0)
        {
            data = (follower*)[self.listByRecently objectAtIndex:indexPath.row];
        }
        else
        {
            data = (follower*)[self.listByFlower objectAtIndex:indexPath.row];
        }
    }
    else
    {
        data = (follower*)[self.searchResultList objectAtIndex:indexPath.row];
    }
    
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.hidesBottomBarWhenPushed = false;
    view.uid = data.uid;

    self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject, view];
}

// MARK: - Actions

- (IBAction)segmentControlValueChanged:(id)sender
{
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        if (self.listByRecently.count > 0)
        {
            [self.tableView reloadData];
        }
        else
        {
            if (self.isFollower)
            {
                [self loadFollowers:-1 sortType:@"time"];
            }
            else
            {
                [self loadFollowings:-1 sortType:@"time"];
            }
        }
    }
    else
    {
        if (self.listByFlower.count > 0)
        {
            [self.tableView reloadData];
        }
        else
        {
            if (self.isFollower)
            {
                [self loadFollowers:-1 sortType:@"flower"];
            }
            else
            {
                [self loadFollowings:-1 sortType:@"flower"];
            }
        }
    }
}

// MARK: - Selectors

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    self.searchResultTableViewBottomMargin.constant = keyboardSize.height;
    [self.searchResultTableView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.searchResultTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    self.searchResultTableViewBottomMargin.constant = 0;
    [self.searchResultTableView setNeedsUpdateConstraints];
    
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    [UIView animateWithDuration:time delay:0 options:option animations:^{
        [self.searchResultTableView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

// MARK: - UISearchbarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:true];
    self.searchResultTableView.hidden = false;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:false];
    [self.searchResultList removeAllObjects];
    [self.searchResultTableView reloadData];
    self.searchResultTableView.hidden = true;
    self.labelNoResult.hidden = true;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""])
    {
        [self searchText:searchText];
    }
}

@end
