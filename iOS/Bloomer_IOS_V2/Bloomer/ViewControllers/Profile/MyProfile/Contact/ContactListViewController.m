//
//  ContactListViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 2/25/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "ContactListViewController.h"


#define FOLLOWER_LIMIT 8
@interface ContactListViewController () {
    UserDefaultManager *userDefaultManager;
    NSInteger lastFollowerUserID;
    NSInteger lastFollowingUserID;
    NSMutableArray *followerList;
    NSMutableArray *followingList;
    BOOL isSearching;
    BOOL isLoading;
    BOOL isFinalFollower;
    BOOL isFinalFollowing;
}
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *followingButton;

@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    //userID = 0;
    followerList = [[NSMutableArray alloc] init];
    followingList = [[NSMutableArray alloc] init];
    
    if (_isFollower) {
        [self onSwitchAlbumsAndAchievements:_followersButton];
    } else{
        [self onSwitchAlbumsAndAchievements:_followingButton];
    }
    [self initNavigationBar];
    [self initSearchhBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissSearchBarKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadFollowerWithLoadMore:NO];
    [self loadFollowingWithLoadMore:NO];
    if (SYSTEM_VERSION_LESS_THAN(@"9")) {
        self.tableView.tableHeaderView = self.searchController.searchBar;
        [self.searchController.searchBar sizeToFit];
        self.searchController.definesPresentationContext = NO;
        self.definesPresentationContext = YES;
//        self.extendedLayoutIncludesOpaqueBars = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self dismissSearchBarKeyboard];
}

- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController == self);
}
//- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
//{
//    if (bar == self.searchController.searchBar) {
//        return UIBarPositionTopAttached;
//    }
//    else { // Handle other cases
//        return UIBarPositionAny;
//    }
//}

-(void)initSearchhBar{
    isSearching = false;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.searchController.searchBar sizeToFit];
    
    self.definesPresentationContext = NO;
    

}

-(void) initNavigationBar{
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:16];
    titleView.textColor = [UIColor whiteColor];
    titleView.text =NSLocalizedString( @"Contact List",nil);
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)loadFollower {
//    profile_follower_fetches_using *API = [[profile_follower_fetches_using alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] /*userID:lastUserID*/ limit:FOLLOWER_LIMIT];
//    API.myDelegate = self;
//    [API connect];
//}

- (void)loadFollowerWithLoadMore:(BOOL)isMore {
    API_Profile_FollowerFetches *api = [[API_Profile_FollowerFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] userID:lastFollowerUserID limit:FOLLOWER_LIMIT isLoadMore:isMore];
    isLoading = TRUE;
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_follower_fetches * data = (out_follower_fetches *) jsonObject;
        isLoading = FALSE;
        if (response.status) {
            isFinalFollower = [data isFinal];
            //        followerList = data.followerList;
            if(api.isLoadMore){
                [followerList addObjectsFromArray:data.followerList];
            } else {
                followerList = data.followerList;
            }
            if(followerList.count>0)
                lastFollowerUserID = ((follower*)followerList[followerList.count-1]).uid;
            
            self.searchResult = [NSMutableArray arrayWithCapacity:[followerList count]];
            if (_isFollower) {
                [_tableView reloadData];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}



//- (void)loadFollowing {
//    profile_following_fetches *API = [[profile_following_fetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken]];
//    API.myDelegate = self;
//    [API connect];
//}
-(void)updateFollowing:(BOOL)isFollow userID:(NSInteger)userID{
    for (follower* user in followingList) {
        if (user.uid == userID) {
            user.is_follow = isFollow;
            [_tableView reloadData];
            break;
        }
    }
}

- (void)loadFollowingWithLoadMore:(BOOL)isMore {
    API_Profile_FollowingFetches *api = [[API_Profile_FollowingFetches alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] userID:lastFollowingUserID limit:FOLLOWER_LIMIT isLoadMore:isMore];
    isLoading = TRUE;
    
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        isLoading = FALSE;
        out_following_fetches * data = (out_following_fetches *) jsonObject;
        if (response.status) {
            //        followingList = data.followingList;
            isFinalFollowing = [data isFinal];
            if(api.isLoadMore){
                [followingList addObjectsFromArray:data.followingList];
            } else {
                followingList = data.followingList;
            }
            if(followingList.count>0)
                lastFollowingUserID = ((follower*)followingList[followingList.count-1]).uid;
            self.searchResult = [NSMutableArray arrayWithCapacity:[followingList count]];
            if (!_isFollower) {
                [_tableView reloadData];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) && !isLoading) {
        //reach bottom
        if (_isFollower) {
            if(!isFinalFollower)
                [self loadFollowerWithLoadMore:YES];
        } else{
            if(!isFinalFollowing)
                [self loadFollowingWithLoadMore:YES];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching)
    {
        return [self.searchResult count];
    }
    else
    {
        if (_isFollower) {
            return followerList.count;
        } else {
            return followingList.count;
        }
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isFollower) {
        NSString *identifier = @"ContactList";
        ContactListTableViewCell *cell = (ContactListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        follower *temp = [[follower alloc]init];
        if (isSearching)
        {
            temp = (follower *)[_searchResult objectAtIndex:indexPath.row];
        }
        else
        {
            temp = (follower *)[followerList objectAtIndex:indexPath.row];
        }
        cell.name.text = temp.name;
        cell.username.text = temp.username;
        if(temp.flower == 0 ){
            cell.flower.text = @"";
        }else {
            cell.flower.text =[NSString stringWithFormat:NSLocalizedString( @"%lld %@ received", nil), temp.flower, temp.flower > 1?NSLocalizedString(@"flowers",nil):NSLocalizedString(@"flower",nil)];
        }
        [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
        cell.uid = temp.uid;
        cell.navigationController = self.navigationController;
//        cell.isChat = temp.is_chat;
        if(!temp.is_chat){
            [cell.chatButton setHidden:YES];
        } else {
            [cell.chatButton setHidden:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        NSString *identifier = @"ContactListFollowing";
        ContactListFollowingTableViewCell *cell = (ContactListFollowingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactListFollowingTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        
        follower *temp = [[follower alloc]init];
        if (isSearching)
        {
            temp = (follower *)[_searchResult objectAtIndex:indexPath.row];
        }
        else
        {
            temp = (follower *)[followingList objectAtIndex:indexPath.row];
        }
        
        cell.name.text = temp.name;
        cell.username.text = temp.username;
        
        if(temp.flower == 0 ){
            cell.flower.text = @"";
        }else {
            cell.flower.text = [NSString stringWithFormat:NSLocalizedString(@"%lld %@ given",nil), temp.flower, temp.flower > 1?NSLocalizedString(@"flowers",nil):NSLocalizedString(@"flower",nil)];
        }
        
        cell.uid = temp.uid;
        cell.parentView = self;

        if(!temp.is_chat){
            [cell.chatButton setHidden:YES];
        } else {
            [cell.chatButton setHidden:NO];
        }
        [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
        
        if (temp.is_follow) {
            [cell.unFollowerButton setHidden:FALSE];
            [cell.followerButton setHidden:TRUE];
        } else {
            [cell.unFollowerButton setHidden:TRUE];
            [cell.followerButton setHidden:FALSE];
        }
        
        cell.userID = temp.uid;
        cell.navigationController = self.navigationController;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (IBAction)segment:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        _isFollower = TRUE;
        [_tableView reloadData];
    } else if (selectedSegment == 1) {
        _isFollower = FALSE;
        [_tableView reloadData];
    }
}

- (IBAction)onSwitchAlbumsAndAchievements:(id)sender{
//    currentIndex = ((UIButton*)sender).tag;
//    [self reloadTableByCurrentIndex];
    [self dismissSearchBarKeyboard];
    switch (((UIButton*)sender).tag) {
        case 0:
            _isFollower = TRUE;
            [_tableView reloadData];
            [_followersButton setSelected:YES];
            [_followingButton setSelected:NO];
            break;
        case 1:
            _isFollower = FALSE;
            [_tableView reloadData];
            [_followersButton setSelected:NO];
            [_followingButton setSelected:YES];
            break;
        default:
            break;
    }
}

#pragma mark - SearchBar

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *searchString = searchController.searchBar.text;
    if( searchString.length > 0 ){
        isSearching = TRUE;
        //    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
        [self.searchResult removeAllObjects];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@",searchString];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"self.username CONTAINS[cd] %@",searchString];
        NSPredicate *resultPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[predicate1, predicate2]];
        if(_isFollower)
        {
//            self.searchResult = [[followerList filteredArrayUsingPredicate:resultPredicate]mutableCopy];
            
            API_Profile_FollowerSearch *api = [[API_Profile_FollowerSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] term_search:searchString];
            isLoading = TRUE;
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                out_follower_search * data = (out_follower_search *) jsonObject;
                isLoading = FALSE;
                if (response.status) {
                    self.searchResult = data.followerList;
                    if (_isFollower) {
                        [_tableView reloadData];
                    }
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            } ErrorHandlure:^(NSError *error) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
        }
        else
        {
//            self.searchResult = [[followingList filteredArrayUsingPredicate:resultPredicate]mutableCopy];
            
            API_Profile_FollowingSearch *api = [[API_Profile_FollowingSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] termSearch:searchString];
            isLoading = TRUE;
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
            [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                isLoading = FALSE;
                out_following_search * data = (out_following_search *) jsonObject;
                if (response.status) {
                    self.searchResult = data.followingList;
                    if (_isFollower == false) {
                        [_tableView reloadData];
                    }
                } else {
                    [AppHelper showMessageBox:nil message:response.message];
                }
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            } ErrorHandlure:^(NSError *error) {
                 [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            }];
        }
        
        [self.tableView reloadData];
    }
    else{
        isSearching = FALSE;
        [self.tableView reloadData];
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [followerList filteredArrayUsingPredicate:resultPredicate] ];
}

- (void) dismissSearchBarKeyboard {
    isSearching = FALSE;
    
    [self.searchController.searchBar endEditing:YES];
    [self.searchController setActive:NO];

}
@end
