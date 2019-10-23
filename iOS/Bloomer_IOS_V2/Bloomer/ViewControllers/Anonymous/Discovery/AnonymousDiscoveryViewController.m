//
//  DiscoveryViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 1/19/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "AnonymousUserProfileViewController.h"
#import "AnonymousDiscoveryViewController.h"
#import "DiscoveryPopupViewController.h"
#import "AppDelegate.h"
#import "UISearchBar+Extension.h"

#define OBJECT_WIDTH 80.0f
#define OBJECT_HEIGHT 80.0f
#define MARGIN_VERTICAL 0.0f
#define MARGIN_HORIZONTAL 0.0f
#define DRAGGABLE_LOCATION_WIDTH  ((OBJECT_WIDTH  * 3) + (MARGIN_HORIZONTAL * 5))
#define DRAGGABLE_LOCATION_HEIGHT ((OBJECT_HEIGHT * 3) + (MARGIN_VERTICAL   * 5))


@interface AnonymousDiscoveryViewController () {
    DiscoveryPopupViewController *popup;
    CGFloat previousContentOffset;
    UserDefaultManager *userDefaultManager;
    NSMutableArray *discoveryList;
    
    NSInteger lastUserID;
    BOOL didReload;
    BOOL giveProfile;
    NSString *postID;
    NSInteger model;
    
    BOOL isSearching;
    NSMutableArray *searchResult;
    
    BOOL isLoading;
    
    BOOL shouldBeginCalledBeforeHand;
    CGRect frameSearchView;
    
    NSInteger currentSearchPage;
    CGFloat tableViewHeight;
    NSTimer *searchDelay;
}

@end

@implementation AnonymousDiscoveryViewController

@synthesize profileData, gender, filterCity, isRefresh, userID, loadedItemIndex, circularMenu, postsPerUserID, searchResultTableView;//, flowerPopup;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    discoveryList = [[NSMutableArray alloc] init];
    postsPerUserID = [[NSMutableDictionary alloc]init];
    
    didReload = FALSE;
    isRefresh = TRUE;
    
    userID = -1;
    lastUserID = -1;
    loadedItemIndex = 0;
    currentSearchPage = 0;
    tableViewHeight = [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - 20 - self.tabBarController.tabBar.frame.size.height - self.searchBar.frame.size.height;
    
    __weak AnonymousDiscoveryViewController *weakSelf = self;
    
    [_tableView addPullToRefreshWithActionHandler:^{
        AnonymousDiscoveryViewController *strongSelf = weakSelf;
        if (strongSelf)
        {
            [strongSelf pullToRefresh];
        }
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf infiniteScrolling];
    }];
    
    [self.searchResultTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreSearch];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:[SinglePhotoCell nibName] bundle:nil] forCellReuseIdentifier:[SinglePhotoCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[TwoPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[TwoPhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[ThreePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[ThreePhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[FourPhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FourPhotosCell cellIdentifier]];
    [self.tableView registerNib:[UINib nibWithNibName:[FivePhotosCell nibName] bundle:nil] forCellReuseIdentifier:[FivePhotosCell cellIdentifier]];
    
    [self.searchResultTableView registerNib:[UINib nibWithNibName:@"RacesSearchTableViewCell" bundle:nil] forCellReuseIdentifier:[RacesSearchTableViewCell cellIdentifier]];
    
    [searchResultTableView setHidden:true];
    searchResultTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.searchBar setupSearchBar];
    
    [self loadCityList];
    [self initNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [_tabbar updateFlowerValue];
    [_tableView reloadData];
    if (_showPopup) {
        [self touchTitle];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Discovery", "")];
}

- (void)touchTitle {
    popup = [[DiscoveryPopupViewController alloc] initWithNibName:@"DiscoveryPopupViewController" bundle:nil];
    popup.parentView = self;
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (void)pullToRefresh {
    isRefresh = TRUE;
    userID = 0;
    loadedItemIndex = 0;
    lastUserID = -1;
    isLoading = FALSE;
    
    [postsPerUserID removeAllObjects];
    
    [self loadDiscovery];
    
    [_tableView.pullToRefreshView stopAnimating];
}

- (void)infiniteScrolling
{
    if (discoveryList.count != 0)
    {
        userID = [(DiscoveryModel *)([discoveryList objectAtIndex:discoveryList.count - 1]) uid];
    }
    else
    {
        userID = 0;
    }
    
    if (userID != lastUserID)
    {
        [self loadDiscovery];
        lastUserID = userID;
    }
    
    [_tableView.infiniteScrollingView stopAnimating];
}

- (void)loadMoreSearch
{
    currentSearchPage += 1;
    
    [self searchAll:self.searchBar.text page:currentSearchPage];
    [self.searchResultTableView.infiniteScrollingView stopAnimating];
}

-(void) saveFilterOptions{
    [userDefaultManager saveDiscoveryOptions:gender location:filterCity];
}

-(void)loadCityList{
    API_Anonymous_LoadLocation *API = [[API_Anonymous_LoadLocation alloc] init];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_location_load * data = (out_location_load *) jsonObject;
        if (response.status) {
            self.cityList = data.citys;
            [self loadDiscoveryOptions];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }

    } ErrorHandlure:^(NSError *error) {
        
    }];
    
}

-(void)loadDiscoveryOptions{
    NSDictionary* discoveryOptions = [userDefaultManager getDiscoveryOptions];
   
    if (discoveryOptions == nil) {
        filterCity = [userDefaultManager getUserProfileData].city;
        gender = [userDefaultManager getUserProfileData].gender;
        [userDefaultManager saveDiscoveryOptions:gender location:filterCity];
    } else {
        gender = [[discoveryOptions objectForKey:@"DicoveryGender"] integerValue];
        filterCity =[discoveryOptions objectForKey:@"DiscoveryCity"] ;
    }
    
    [self loadDiscovery];
}

- (void)loadDiscovery {
    if (isLoading) {
        return;
    }
    isLoading = TRUE;
    NSString *cityStr = @"hcm";
    if (filterCity != nil && filterCity.city_short_name.length) {
        cityStr = filterCity.city_short_name;
    }
    API_DiscoveryFetches *request = [[API_DiscoveryFetches alloc] initWithGender:-1
                                                                    city:cityStr
                                                              is_refresh:isRefresh
                                                                     uid:userID];
    __weak typeof(self) weakSelf = self;
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (data.status) {
                if (isRefresh) {
                    [discoveryList removeAllObjects];
                }
                isLoading = FALSE;
                isRefresh = FALSE;
                JSON_DiscoveryFetches *model = (JSON_DiscoveryFetches *)json;
                
                if (loadedItemIndex == 0) {
                    discoveryList = [model.discoveryList mutableCopy];
                    [strongSelf.tableView reloadData];
                    [strongSelf.tableView scrollsToTop];
                    loadedItemIndex = discoveryList.count;
                } else {
                    if (model.discoveryList.count != 0) {
                        NSMutableArray *temp = [model.discoveryList mutableCopy];
                        [discoveryList addObjectsFromArray:temp];
                        [strongSelf.tableView reloadData];
                        loadedItemIndex = discoveryList.count;
                    }
                }
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:data.message
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil]];
                [strongSelf presentViewController:alert animated:true completion:nil];
            }
        }
        
    } ErrorHandlure:^(NSError *err) {
        NSLog(@"Anonymous Discovery Fetches RequestFailed");
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]])
    {
        return NO;
    }
    ;
    if (circularMenu != nil)
    {
        [circularMenu removeFromSuperview];
    }
    
    return YES;
}

#pragma mark - UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _tableView)
    {
        DiscoveryModel *temp = (DiscoveryModel *)[discoveryList objectAtIndex:indexPath.row];
        
        if (temp.totalPost == 1)
        {
            return [SinglePhotoCell cellHeight];
        }
        
        if (temp.totalPost == 2)
        {
            return [TwoPhotosCell cellHeight];
        }
        
        if (temp.totalPost == 3)
        {
            return [ThreePhotosCell cellHeight];
        }
        
        if (temp.totalPost == 4)
        {
            return [FourPhotosCell cellHeight];
        }
        
        if (temp.totalPost == 5)
        {
            return [FivePhotosCell cellHeight];
        }
        
        return 0;
    }
    else
    {
        return 45;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == searchResultTableView)
    {
        return searchResult.count;
    }
    else
    {
        return discoveryList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == _tableView)
    {
        DiscoveryModel *temp = (DiscoveryModel *)[discoveryList objectAtIndex:indexPath.row];
        
        if (temp.totalPost == 1)
        {
            // Single cell
            SinglePhotoCell *cell = (SinglePhotoCell*)[tableView dequeueReusableCellWithIdentifier:[SinglePhotoCell cellIdentifier]];
            feed_pic *feedPic = (feed_pic*)temp.posts.firstObject;
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.post_id = feedPic.photo_id;
            cell.post_url = feedPic.photo_url;
            
            //            if (![self.tabbar.draggableButton.droppableLocations containsObject:cell.topDraggableLocation])
            //            {
            // init give flower area for profile

            [cell.photo setImageWithURL:[NSURL URLWithString:feedPic.photo_url]];
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 2)
        {
            // Three Photos cell
            TwoPhotosCell *cell = (TwoPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[TwoPhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPosts = [temp.posts copy];
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithURL:[NSURL URLWithString:feedPic.photo_url]];
            }
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 3)
        {
            // Three Photos cell
            ThreePhotosCell *cell = (ThreePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[ThreePhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithURL:[NSURL URLWithString:feedPic.photo_url]];
            }
            
    //        feed_pic *lastFeedPic = (feed_pic*)temp.posts.lastObject;
    //        UIImageView *lastPhotoView = (UIImageView*)cell.photos.lastObject;
    //        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:lastFeedPic.photo_url]];
    //        
    //        [lastPhotoView setImageWithURLRequest:urlRequest placeholderImage:[[UIImage alloc] init] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //            
    //            cell.photoLoadTime += 1;
    //            [cell setLastPhotoWithImage:image];
    //            
    //            if (cell.photoLoadTime < 2)
    //            {
    //                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //            }
    //            
    //        } failure:NULL];
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 4)
        {
            // Three Photos cell
            FourPhotosCell *cell = (FourPhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FourPhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithURL:[NSURL URLWithString:feedPic.photo_url]];
            }
            
    //        feed_pic *lastFeedPic = (feed_pic*)temp.posts.lastObject;
    //        UIImageView *lastPhotoView = (UIImageView*)cell.photos.lastObject;
    //        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:lastFeedPic.photo_url]];
    //        
    //        [lastPhotoView setImageWithURLRequest:urlRequest placeholderImage:[[UIImage alloc] init] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
    //            
    //            cell.photoLoadTime += 1;
    //            [cell setLastPhotoWithImage:image];
    //            
    //            if (cell.photoLoadTime < 2)
    //            {
    //                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //            }
    //            
    //        } failure:NULL];
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        
        if (temp.totalPost == 5)
        {
            // Three Photos cell
            FivePhotosCell *cell = (FivePhotosCell*)[tableView dequeueReusableCellWithIdentifier:[FivePhotosCell cellIdentifier]];
            
            cell.navigationController = self.navigationController;
            cell.parentTableView = tableView;
            cell.cellIndex = indexPath;
            cell.uid = temp.uid;
            cell.tabbar = self.tabbar;
            cell.feedPics = [temp.posts copy];
            
            for (NSInteger i = 0; i < temp.posts.count; i++)
            {
                feed_pic *feedPic = (feed_pic*)temp.posts[i];
                UIImageView *photo = (UIImageView*)cell.photos[i];
                [photo setImageWithURL:[NSURL URLWithString:feedPic.photo_url]];
            }
            
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.labelUsername.text = temp.username;
            cell.labelName.text = temp.name;
            cell.labelFlowerWidth.constant = 0;
            cell.labelTimeWidth.constant = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
    } else if (tableView == searchResultTableView ) {
        if (searchResult.count != 0) {
            RacesSearchTableViewCell *cell = (RacesSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:[RacesSearchTableViewCell cellIdentifier]
                                                                                                         forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (![cell isKindOfClass:RacesSearchTableViewCell.class]) {
                return cell;
            }
            
            DiscoveryModel *temp = (DiscoveryModel *)searchResult[indexPath.row];
            [cell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
            cell.name.text = temp.name;
            cell.username.text = temp.username;
            cell.rank.text = @"";//[NSString stringWithFormat:@"#%@", @(temp.rank).stringValue];
            
            return cell;
        }
    }
    
    return [[UITableViewCell alloc] init];
}

//-(void)  tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    DiscoveryTableViewCell *customCell = (DiscoveryTableViewCell *)cell;
//
//    discovery *temp = [[discovery alloc]init];
//    if (isSearching)
//    {
//        temp = (discovery *)[searchResult objectAtIndex:indexPath.row];
//    }
//    else
//    {
//        temp = (discovery *)[discoveryList objectAtIndex:indexPath.row];
//    }
//
//    [customCell.avatar setImageWithURL:[NSURL URLWithString:temp.avatar]];
//    customCell.name.text = temp.name;
//    customCell.username.text = temp.username;
//    customCell.navigationController = self.navigationController;
//    if (temp.received_flower <= 1) {
//        customCell.receivedFlower.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nflower",nil), @(temp.received_flower).stringValue];
//    } else {
//        customCell.receivedFlower.text = [NSString stringWithFormat:NSLocalizedString(@"%@\nflowers",nil), @(temp.received_flower).stringValue];
//    }
//
//    customCell.userID = temp.uid;
//    customCell.postList = [postsPerUserID objectForKey:@(temp.uid).stringValue];
//    if (customCell.postList == nil || [customCell.postList count]==0) {
//        [customCell loadPosts];
//    } else {
//        [customCell initSlideShow];
//    }
//
//    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    customCell.parentView = self;
//    customCell.index = indexPath.row + 1;
//    customCell.count = discoveryList.count;
//
//    [self configureDraggableLocation:customCell.draggableLocationTop makeCircle:NO];
//    customCell.draggableLocationTop.delegate = self;
//    customCell.draggableLocationTop.index = indexPath;
//    if (indexPath.row == 0) {
//        customCell.draggableLocationTop.thankyouStyle = 4;
//    }
//    [_tabbar.draggableButton addAllowedDropLocation:customCell.draggableLocationTop];
//    [_listDraggableLocationTop addObject:customCell.draggableLocationTop];
//}

//- (void) tableView: (UITableView *) tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *) indexPath{
//    DiscoveryTableViewCell *cell = (DiscoveryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    [cell hideThankYou];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == searchResultTableView && searchResult.count > indexPath.row) {
        RacesObj *temp = (RacesObj *)[searchResult objectAtIndex:indexPath.row];
        isSearching = false;
        if([userDefaultManager isAnonymous]) {
            AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
            view.uid = temp.uid;
            [self.navigationController pushViewController:view animated:YES];
        } else {
            UserProfileViewController *view;
            view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            view.uid = temp.uid;
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        previousContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
    }
}

#pragma mark - SearchBar
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchResultTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [searchResultTableView setHidden:false];
    
    currentSearchPage = 0;
    
    if (searchText.length > 0)
    {
        isSearching = TRUE;
        [searchResult removeAllObjects];
        
        if(searchDelay != nil) {
            [searchDelay invalidate];
            searchDelay = nil;
        }
        searchDelay = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(searchAll:) userInfo:searchText repeats:NO];
    }
    else
    {
        isSearching = FALSE;
        [searchResult removeAllObjects];
        
        searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [searchResultTableView reloadData];
    }
}

- (void)searchAll:(NSTimer*)timer {
    NSString *searchText = (NSString*)[timer userInfo];
    //    NSInteger currentSearchPage = [[dict objectForKey:@"currentSearchPage"] integerValue];
    [self searchAll:searchText page:currentSearchPage];
}

- (void)searchAll:(NSString*)textSearch page:(NSInteger)page {
    // search ONLINE
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_DiscoverySearch *api = [[API_DiscoverySearch alloc] initWithTerm:textSearch
                                                                    size:20
                                                                    page:page];
    __weak typeof(self) weakSelf = self;
    [api getRequest:^(BaseJSON *json, RestfulResponse *response) {
        if (weakSelf) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                JSON_DiscoverySearch *jsonModel = (JSON_DiscoverySearch *)json;
                if(jsonModel.searchList.count == 0) {
                    if (currentSearchPage == 0) {
                        [searchResult removeAllObjects];
                    }
                    [searchResultTableView reloadData];
                } else {
                    if (currentSearchPage == 0) {
                        searchResult = jsonModel.searchList;
                    } else {
                        [searchResult addObjectsFromArray:jsonModel.searchList];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [searchResultTableView reloadData];
                        if (currentSearchPage == 0) {
                            NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
                            [strongSelf.searchResultTableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    });
                }
            } else {
                [Support addErrorMessage:response.message intoView:strongSelf.view];
            }
        }
        
    } ErrorHandlure:^(NSError *error) {
        NSLog(@"API_AnonymousDiscoverySearch failed");
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    isSearching = true;
    self.tableView.userInteractionEnabled = false;
    
    [searchResultTableView setHidden:false];
    [searchResultTableView reloadData];
    
    return YES;
}

- (void)keyboardWillChange:(NSNotification *)notification {

    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGRect SelfViewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGRect SearchView = [self.searchBar.window convertRect:self.searchBar.bounds fromView:self.view];
    
    CGFloat ViewSearchSize = SelfViewRect.size.height - (keyboardRect.size.height + SearchView.size.height);
    
    CGRect frame = self.searchResultTableView.frame;
    frame.size.height = ViewSearchSize ;
    if(isSearching)
    {
        self.searchResultTableView.frame = frame;
        [self.searchResultTableView setHidden:false];
    }
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchResult removeAllObjects];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    searchBar.text = @"";
    isSearching = false;
    
    [searchResultTableView setHidden:true];
    [self.searchResultTableView reloadData];
    
    self.tableView.userInteractionEnabled = true;
    [self.view endEditing:YES];
}

-(void) removeAllowedDropLocationsInList:(NSMutableArray* )locations {
    for (SEDraggableLocation *location in locations)
    {
        [_tabbar.draggableButton removeAllowedDropLocation:location];
    }
}

// MARK: - Selectors

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval time = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions option = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedLongValue];
    
    self.searchResultTableViewBottomMargin.constant = keyboardSize.height - self.tabBarController.tabBar.frame.size.height;
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

@end
