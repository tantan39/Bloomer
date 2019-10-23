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
#import "MySettingViewController.h"
#import "BloomerMenuPopUpView.h"
#import "BloomerActionSheet.h"

#define LIMIT_FETCH 10

@interface FlowerRelationViewController () {
    Spinner *spinner;
    UISearchController* searchController;
    NSTimer *searchTimer;
}

@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) NSMutableArray *listByRecently;
@property (strong, nonatomic) NSMutableArray *listByFlower;
@property (strong, nonatomic) NSMutableArray *searchResultList;
@property (assign, nonatomic) BOOL loadMoreRecently;
@property (assign, nonatomic) BOOL loadMoreByFlower;

@end

@implementation FlowerRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [self.userDefaultManager getUserProfileData];
    self.listByRecently = [[NSMutableArray alloc] init];
    self.listByFlower = [[NSMutableArray alloc] init];
    self.loadMoreRecently = false;
    self.loadMoreByFlower = false;
    [self initNavigationBar];
    [self setUpSearchBar];
    self.automaticallyAdjustsScrollViewInsets = false;
    
//    self.segmentControl.layer.cornerRadius = self.segmentControl.frame.size.height / 2;
//    self.segmentControl.layer.borderWidth = 1.5;
////    self.segmentControl.layer.borderColor = [UIColor colorFromHexString:@"#B22225"].CGColor;
//    self.segmentControl.clipsToBounds = true;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:14], NSFontAttributeName,
                                [UIColor rgb:119 green:119 blue:119], NSForegroundColorAttributeName,
                                nil];
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14 weight:0.3], NSFontAttributeName, [UIColor rgb:37 green:37 blue:41], NSForegroundColorAttributeName,nil];
    [self.segmentControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    
    [self.recentlytableView registerNib:[UINib nibWithNibName:[FlowerRelationCell nibName] bundle:nil] forCellReuseIdentifier:[FlowerRelationCell cellIdentifier]];
    [self.byFlowersTableView registerNib:[UINib nibWithNibName:[FlowerRelationCell nibName] bundle:nil] forCellReuseIdentifier:[FlowerRelationCell cellIdentifier]];
    [self.searchResultTableView registerNib:[UINib nibWithNibName:[FlowerRelationCell nibName] bundle:nil] forCellReuseIdentifier:[FlowerRelationCell cellIdentifier]];

    self.segmentControl.selectedSegmentIndex = self.tabIndex;

    [self.recentlytableView addInfiniteScrollingWithActionHandler:^{
        NSInteger lastUID = -1;
        self.loadMoreRecently = true;
        
        if (self.isFollower)
        {
            if (self.listByRecently.count > 0)
            {
                follower *data = (follower*)[self.listByRecently lastObject];
                lastUID = data.uid;
            }
            
            [self loadFollowers:lastUID sortType:@"time" typeLoad:RECENTLY];
        }
        else
        {
            if (self.listByRecently.count > 0)
            {
                follower *data = (follower*)[self.listByRecently lastObject];
                lastUID = data.uid;
            }
            
            [self loadFollowings:lastUID sortType:@"time" typeLoad: RECENTLY];
        }
    }];
    
    [self.byFlowersTableView addInfiniteScrollingWithActionHandler:^{
        NSInteger lastUID = -1;
        self.loadMoreByFlower = true;
        
        if (self.isFollower)
        {
            if (self.listByFlower.count > 0)
            {
                follower *data = (follower*)[self.listByFlower lastObject];
                lastUID = data.uid;
            }
            
            [self loadFollowers:lastUID sortType:@"flower" typeLoad: BYFLOWER];
        }
        else
        {
            if (self.listByFlower.count > 0)
            {
                follower *data = (follower*)[self.listByFlower lastObject];
                lastUID = data.uid;
            }
            
            [self loadFollowings:lastUID sortType:@"flower" typeLoad: BYFLOWER];
        }
    }];
    
    if (self.isFollower)
    {
        [self loadFollowers:-1 sortType:@"time" typeLoad:RECENTLY];
        [self loadFollowers:-1 sortType:@"flower" typeLoad:BYFLOWER];
    }
    else
    {
        [self loadFollowings:-1 sortType:@"time" typeLoad: RECENTLY];
        [self loadFollowings:-1 sortType:@"flower" typeLoad: BYFLOWER];
    }
    
    spinner = ((AppDelegate*)[UIApplication sharedApplication].delegate).spinner;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.tabBarController.tabBar setHidden:TRUE];
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

- (void) setUpSearchBar {
    searchController = [[UISearchController alloc] initWithSearchResultsController: nil];
    searchController.searchBar.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = false;
    searchController.searchBar.placeholder = NSLocalizedString(@"WinnersClub.searchPlaceHolder",);
    searchController.searchBar.backgroundImage = [[UIImage alloc] init];
    searchController.searchBar.backgroundColor = [UIColor whiteColor];
    searchController.searchBar.barTintColor = [UIColor whiteColor];
    searchController.searchBar.tintColor = [UIColor rgb:68 green:68 blue:68];
    self.definesPresentationContext = TRUE;
    self.automaticallyAdjustsScrollViewInsets = FALSE;
    [searchController.searchBar setupSearchBar];
    [searchController.searchBar customizeGrayThemeSearchBar];
    searchController.searchBar.showsScopeBar = NO;
    UITextField *textField = [searchController.searchBar valueForKey:@"_searchField"];
    textField.tintColor = [UIColor rgb:119 green:119 blue:119];
    searchController.delegate = self;
    [searchController.searchBar setValue: [AppHelper getLocalizedString: @"ChangeProfileViewController.cancel"] forKey:@"_cancelButtonText"];
    [self addSearchBar];
}

- (void) addSearchBar {
    self.searchResultTableView.tableHeaderView  = searchController.searchBar;
    [self.searchResultTableView.tableHeaderView sizeToFit];
}

- (void)setupLanguage
{
    [self.segmentControl setTitle:[AppHelper getLocalizedString:@"FlowerRelation.tabRecently"] forSegmentAtIndex:0];
    [self.segmentControl setTitle:[AppHelper getLocalizedString:@"FlowerRelation.tabByFlowers"] forSegmentAtIndex:1];
    self.labelNoResult.text = [AppHelper getLocalizedString:@"FlowerRelation.labelNoResult"];
}

- (void)initNavigationBar
{
    if (self.isFollower)
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:[AppHelper getLocalizedString:@"FlowerRelation.receivers"]];
    }
    else
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:[AppHelper getLocalizedString:@"FlowerRelation.givers"]];
    }
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStylePlain target:self action:@selector(touchSearchButton)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:/*notificationButton,*/ searchButton, nil]];
    
}

- (void)touchSearchButton
{
    [searchController setActive: TRUE];
    UIView* header = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchResultTableView.tableHeaderView = header;
    [self.searchResultTableView.tableHeaderView sizeToFit];

}
- (void)createTimerSearching:(NSString *)searchText {
    [searchTimer invalidate];
    searchTimer = nil;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"searchStr"] = searchText;
    searchTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target:[WeakLinkObj weakObjectWithRealTarget:self]
                                                 selector:@selector(invokeSearchingWithTimer:)
                                                 userInfo:userInfo
                                                  repeats:false];
}

- (void)invokeSearchingWithTimer:(NSTimer *)timer {
    NSString *searchText = [timer userInfo][@"searchStr"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       if ([searchText isEqualToString:@""]) {
                           return;
                       }
                        [self searchText:searchText];
                   });
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

- (void)loadFollowers:(NSInteger)uid sortType:(NSString*)sortType typeLoad: (TypeRelation) type
{
//    [spinner startAnimating];
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
            
            if (type == RECENTLY)
            {
                if (self.loadMoreRecently)
                {
                    [self.listByRecently addObjectsFromArray:data.followerList];
                    self.loadMoreRecently = false;
                    [self.recentlytableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByRecently = data.followerList;
                }
                [self.recentlytableView reloadData];

            }
            else
            {
                if (self.loadMoreByFlower)
                {
                    [self.listByFlower addObjectsFromArray:data.followerList];
                    self.loadMoreByFlower = false;
                    [self.byFlowersTableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByFlower = data.followerList;
                }
            }
            [self.byFlowersTableView reloadData];
        }
        else
        {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [spinner stopAnimating];
    }];
    
}

- (void)loadFollowings:(NSInteger)uid sortType:(NSString*)sortType typeLoad: (TypeRelation) type
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
            
            if (type == RECENTLY)
            {
                if (self.loadMoreRecently)
                {
                    [self.listByRecently addObjectsFromArray:data.followingList];
                    self.loadMoreRecently = false;
                    [self.recentlytableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByRecently = data.followingList;
                }
                [self.recentlytableView reloadData];
            }
            else
            {
                if (self.loadMoreByFlower)
                {
                    [self.listByFlower addObjectsFromArray:data.followingList];
                    self.loadMoreByFlower = false;
                    [self.byFlowersTableView.infiniteScrollingView stopAnimating];
                }
                else
                {
                    self.listByFlower = data.followingList;
                }
                [self.byFlowersTableView reloadData];
            }
            
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
    
    if (tableView == self.recentlytableView) {
        return self.listByRecently.count;
    } else if (tableView == self.byFlowersTableView) {
        return self.listByFlower.count;
    } else {
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

    if (tableView == self.recentlytableView) {
        if (self.listByRecently.count > 0) {
            data = (follower*)[self.listByRecently objectAtIndex:indexPath.row];
        }
    } else if (tableView == self.byFlowersTableView) {
        if (self.listByFlower.count > 0) {
            data = (follower*)[self.listByFlower objectAtIndex:indexPath.row];
        }
    } else {
        data = (follower*)[self.searchResultList objectAtIndex:indexPath.row];
    }
    
    cell.navigationController = self.navigationController;
    cell.data = data;
    
    [cell.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
    cell.labelName.text = data.name;
    cell.labelUsername.text = data.username;
    cell.labelFlower.text = @(data.flower).stringValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.timestamp];
    cell.labelTime.text = [[date timeAgo] stringByAppendingFormat:@" ago"];
    
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
    
    if (tableView == self.recentlytableView) {
        data = (follower*)[self.listByRecently objectAtIndex:indexPath.row];
    } else if (tableView == self.byFlowersTableView) {
        data = (follower*)[self.listByFlower objectAtIndex:indexPath.row];
    } else {
        data = (follower*)[self.searchResultList objectAtIndex:indexPath.row];
    }
    
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    view.hidesBottomBarWhenPushed = false;
    view.uid = data.uid;
    [self.navigationController pushViewController:view animated:TRUE];
//    self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject, view];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.recentlytableView && scrollView != self.byFlowersTableView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        if (offsetX > scrollView.frame.size.width /4 && self.segmentControl.selectedSegmentIndex == 0) {
            self.segmentControl.selectedSegmentIndex = 1;
            [self handelChangeTab];
        } else if (offsetX < scrollView.frame.size.width /4 && self.segmentControl.selectedSegmentIndex == 1) {
            self.segmentControl.selectedSegmentIndex = 0;
            [self handelChangeTab];
        }
        
        if (offsetX < 15) {
            offsetX = 15;
        } else if (offsetX > scrollView.frame.size.width / 2) {
            offsetX = scrollView.frame.size.width / 2;
        }
        self.animationLineLeadingConstraint.constant = offsetX;
    }
    //    [self animateLine:offsetX / 3];
    
//    self.animatedLineLeftMargin.constant = offsetX/3;
//    if (offsetX / 3 == self.membershipButton.frame.origin.x) {
//        //        [self.membershipButton didTouchButton];
//    }
//    if ((int) offsetX / 3 == (int) self.currentRankButton.frame.origin.x) {
//        //        [self.currentRankButton didTouchButton];
//    }
//    if ((int) offsetX / 3 == (int) self.topResultButton.frame.origin.x) {
//        //        [self.topResultButton didTouchButton];
//    }
}

// MARK: - Actions

- (IBAction)segmentControlValueChanged:(id)sender
{
    CGFloat x = 0;
    if (self.segmentControl.selectedSegmentIndex == 1) {
        x = self.scrollView.frame.size.width;
    }
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:true];
    [self handelChangeTab];
    
}

- (void) handelChangeTab {
    if (self.segmentControl.selectedSegmentIndex == 0)
    {
        if (self.listByRecently.count > 0)
        {
            [self.recentlytableView reloadData];
        }
        else
        {
            if (self.isFollower)
            {
                [self loadFollowers:-1 sortType:@"time" typeLoad:RECENTLY];
            }
            else
            {
                [self loadFollowings:-1 sortType:@"time" typeLoad: RECENTLY];
            }
        }
    }
    else
    {
        if (self.listByFlower.count > 0)
        {
            [self.byFlowersTableView reloadData];
        }
        else
        {
            if (self.isFollower)
            {
                [self loadFollowers:-1 sortType:@"flower" typeLoad:BYFLOWER];
            }
            else
            {
                [self loadFollowings:-1 sortType:@"flower" typeLoad:BYFLOWER];
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

- (void) resetSearch {
    [self.searchResultList removeAllObjects];
    [self.searchResultTableView reloadData];
    self.labelNoResult.hidden = true;
}

- (void) hiddenAndShowTable: (BOOL) show {
    self.scrollView.hidden = show;
    self.searchResultTableView.hidden = !show;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:true];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self resetSearch];
    [self createTimerSearching:searchText];
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    [self hiddenAndShowTable:FALSE];
    searchController.searchBar.text = @"";
    [self resetSearch];
    [self addSearchBar];
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    [searchController.searchBar becomeFirstResponder];
    [searchController.searchBar customizeCancelSearchBar];
    [self hiddenAndShowTable:TRUE];
}

@end
