//
//  WinnersClubViewController.m
//  Bloomer
//
//  Created by Ahri on 10/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "WinnersClubViewController.h"
#import "RacesSearchTableViewCell.h"

@interface WinnersClubViewController ()
{
    UserDefaultManager *userDefaultManager;
    BOOL searchActivated;
    NSTimer *searchTimer;
    
    PopupForGSB *popup;
    
    NSMutableArray<WinnerObj *> *winners;
    NSMutableArray<WinnerObj *> *searchWinners;
    NSNumber *lastUID;
    NSInteger lastPage;
    NSString *curSearchTerm;
}

@end

@implementation WinnersClubViewController

// MARK: - View Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [searchTimer invalidate];
    searchTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.gsbType == GSBBronze) {
        self.title = NSLocalizedString(@"WinnersClub.bronzeClubTitle",);
    } else if (self.gsbType == GSBSilver) {
        self.title = NSLocalizedString(@"WinnersClub.silverClubTitle",);
    } else if (self.gsbType == GSBGold) {
        self.title = NSLocalizedString(@"WinnersClub.goldClubTitle",);
    }
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RacesTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"RacesTableViewCell"];
    [self.searchResultTableView registerNib:[UINib nibWithNibName:@"RacesSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"RacesSearchTableViewCell"];
    
    // Init datas
    winners = [[NSMutableArray alloc] init];
    searchWinners = [[NSMutableArray alloc] init];
    lastPage = 0;
    
    // Setup UI Actions
    __weak typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf tablePullToRefresh];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf tableInfiniteScrolling];
    }];
    
    // Customize default UI
    self.notFoundLabel.hidden = true;
    self.notFoundLabel.text = NSLocalizedString(@"LeaderboardNotFoundSearchList.title",);
    [self initNavigationBar];
    [self customizeSearchbar];
    self.tableView.estimatedRowHeight = 120;
    self.tableView.tableFooterView = [UIView new];
    
    // Invoke APIs
    [self invokeAPI_WinnersClubLastUserID:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setTranslucent:true];
    [self.tabBarController.tabBar setHidden:true];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// MARK: - UI Customization

- (void)initNavigationBar {
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoButton setImage:[UIImage imageNamed:@"Icon_Leaderboard_More"] forState:UIControlStateNormal];
    infoButton.frame = CGRectMake(0, 0, 35, 35);
    [infoButton addTarget:self action:@selector(touchInfoButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.navigationItem setRightBarButtonItem:infoButtonItem];
}

- (void)customizeSearchbar {
    [self.searchBar setPlaceholder:NSLocalizedString(@"WinnersClub.searchPlaceHolder",)];
    [self.searchBar customizeWhiteThemeSearchBar];
}

- (void)touchInfoButton {
    popup = [[PopupForGSB alloc] initWithNibName:@"PopupForGSB" bundle:nil];
    if (self.gsbType == GSBBronze) {
        popup.gsbType = @"B";
    }
    if (self.gsbType == GSBSilver) {
        popup.gsbType = @"S";
    }
    if (self.gsbType == GSBGold) {
        popup.gsbType = @"G";
    }
    [popup showInView:[[UIApplication sharedApplication] keyWindow] animated:true];
}

// MARK: - Table Refresh actions

- (void)tablePullToRefresh {
    if (searchActivated) {
        if (curSearchTerm.length != 0) {
            lastPage = 0;
            [self invokeAPI_WinnersClubSearchWithTerm:curSearchTerm];
        }
        
    } else {
        lastUID = nil;
        [self invokeAPI_WinnersClubLastUserID:lastUID];
    }
}

- (void)tableInfiniteScrolling {
    if (searchActivated) {
        [self invokeAPI_WinnersClubSearchWithTerm:curSearchTerm];
    } else {
        if (winners.count != 0) {
            lastUID = [NSNumber numberWithInteger:((WinnerObj *)winners.lastObject).uid];
        } else {
            lastUID = nil;
        }
        [self invokeAPI_WinnersClubLastUserID:lastUID];
    }
}

// MARK: - APIs

- (void)invokeAPI_WinnersClubLastUserID:(NSNumber *)lastID {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_WinnersClub *api = [[API_WinnersClub alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                           device_token:[userDefaultManager getDeviceToken]
                                                                    gsb:self.gsbType
                                                                 gender:self.gender
                                                                    uid:lastID];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        
        if (response.status) {
            JSON_WinnersClub *winnersJSON = (JSON_WinnersClub *)jsonObject;
            if (lastID != nil) {
                [winners addObjectsFromArray:winnersJSON.winners];
            } else {
                winners = winnersJSON.winners;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)invokeAPI_WinnersClubSearchWithTerm:(NSString *)term {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_WinnersClubSearch *api = [[API_WinnersClubSearch alloc] initWithAccessToken:[userDefaultManager getAccessToken]
                                                                       device_token:[userDefaultManager getDeviceToken]
                                                                                gsb:self.gsbType
                                                                             gender:self.gender
                                                                               page:lastPage
                                                                               size:(NSInteger)20
                                                                               term:(NSString *)term];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
        
        if (response.status) {
            JSON_WinnersClub *winnersJSON = (JSON_WinnersClub *)jsonObject;
            if (lastPage != 0) {
                [searchWinners addObjectsFromArray:winnersJSON.winners];
            } else {
                searchWinners = winnersJSON.winners;
            }
            if (searchWinners.count == 0) {
                self.notFoundLabel.hidden = false;
            } else {
                self.notFoundLabel.hidden = true;
                lastPage += 1;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchResultTableView reloadData];
            });
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

// MARK: - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView)
    {
        return 80;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView)
    {
        return winners.count;
    }
    else
    {
        return searchWinners.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // RacesTableViewCell, RacesSearchTableViewCell
    if (tableView == self.tableView) {
        RacesTableViewCell *cell = (RacesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[RacesTableViewCell cellIdentifier]
                                                                                         forIndexPath:indexPath];
        
        cell.TopRankImage.image = [UIImage imageNamed:@"icon_video_blue"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellIndex = indexPath;
        cell.tableView = self.tableView;
        
//        WinnerObj *winner = nil;
//        if (searchActivated) {
//            winner = (WinnerObj *)searchWinners[indexPath.row];
//        } else {
//            winner = (WinnerObj *)winners[indexPath.row];
//        }
        
        WinnerObj *winner = (WinnerObj *)winners[indexPath.row];
        
        cell.name.text = winner.name;
        cell.username.text = winner.username;
        cell.avatarString = winner.avatar;
        [cell.avatar setImageWithURL:[NSURL URLWithString:winner.avatar]];
        
        cell.numFlower.text = @(winner.flower).stringValue;
        if (winner.flower > 1) {
            cell.lblFlowerText.text = NSLocalizedString(@"flowers",);
        } else {
            cell.lblFlowerText.text = NSLocalizedString(@"flower",);
        }
        cell.tag = winner.uid;
        cell.uid = winner.uid;
        cell.MyNavigationController = self.navigationController;
        cell.parentView = self;
        [cell.statusButton setHidden:true];
        [cell.statusLabel setHidden:true];
        [cell.iconStatus setHidden:true];
        cell.number.text = @"";
        [cell switchStyleForAvatarBorderViewWithMedal:winner.gsb_medal isIcon:winner.is_icon];
        [cell setVideoLink:winner.video];
        cell.topRankImageTrailingConstraint.constant = 0;
        
        return cell;
    }
    
    if (tableView == self.searchResultTableView)
    {
        NSString *identifier = @"RacesSearchTableViewCell";
        RacesSearchTableViewCell *cell = (RacesSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        WinnerObj *winner = (WinnerObj *)searchWinners[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.seeMoreButton setHidden:YES];
        [cell.avatar setImageWithURL:[NSURL URLWithString:winner.avatar]];
        cell.name.text = winner.name;
        cell.username.text = winner.username;
//        cell.rank.text = [NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

// MARK: - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView || tableView == self.searchResultTableView) {
        WinnerObj *temp = nil;
        if (searchActivated) {
            temp = (WinnerObj *)searchWinners[indexPath.row];
        } else {
            temp = (WinnerObj *)winners[indexPath.row];
        }
        
        if (temp.uid == [userDefaultManager getUserProfileData].uid) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.tabBarView.selectedIndex != 4) {
                [appDelegate.tabBarView setSelectedIndex:4];
            } else {
                for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                    UIViewController *targetView = self.navigationController.viewControllers[i];
                    if ([targetView isKindOfClass:[MyProfileViewController class]]) {
                        [self.navigationController popToViewController:targetView animated:true];
                        break;
                    }
                }
            }
            
        } else {
            UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            view.uid = temp.uid;
            
            // Show TabBar when push
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (NSInteger i = (viewControllers.count - 1); i >= 0; i--) {
                UIViewController *view = viewControllers[i];
                if ([view isKindOfClass:[MembershipViewController class]]) {
                    view.hidesBottomBarWhenPushed = false;
                    break;
                }
            }

            [self.navigationController pushViewController:view animated:true];
        }
    }
}

// MARK: - Actions

// MARK - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:true animated:true];
    self.tableView.hidden = true;
    self.searchResultTableView.hidden = false;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    lastPage = 0;
    searchActivated = true;
    [searchWinners removeAllObjects];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultTableView reloadData];
    });
    [self createTimerSearching:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchActivated = true;
    [self createTimerSearching:searchBar.text];
}

- (void)createTimerSearching:(NSString *)searchText {
    [searchTimer invalidate];
    searchTimer = nil;
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    userInfo[@"searchStr"] = searchText;
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[WeakLinkObj weakObjectWithRealTarget:self]
                                                 selector:@selector(invokeSearchingWithTimer:)
                                                 userInfo:userInfo
                                                  repeats:false];
}

- (void)invokeSearchingWithTimer:(NSTimer *)timer {
    NSString *searchText = [timer userInfo][@"searchStr"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       if ([searchText isEqualToString:@""]) {
                           return;
                       }
                       
                       curSearchTerm = searchText;
                       [self invokeAPI_WinnersClubSearchWithTerm:searchText];
                   });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:false animated:true];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    searchActivated = false;

    self.notFoundLabel.hidden = true;
    self.searchResultTableView.hidden = true;
    self.tableView.hidden = false;
    
    searchWinners = [[NSMutableArray alloc] init];
    lastPage = 0;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//        [self.tableView layoutIfNeeded];
//
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
//                              atScrollPosition:UITableViewScrollPositionTop animated:false];
//    });
}

// MARK - Scroll Delegates

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}

// MARK - Keyboard Observer

- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *keyboardInfo = [noti userInfo];
    CGRect keyboardRect = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.searchResultTableViewBottomMargin.constant = keyboardRect.size.height;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.searchResultTableView layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    NSDictionary *keyboardInfo = [noti userInfo];
    CGFloat keyboardAnimationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.searchResultTableViewBottomMargin.constant = 0;
    [UIView animateWithDuration:keyboardAnimationDuration animations:^{
        [self.searchResultTableView layoutIfNeeded];
    }];
}

@end
