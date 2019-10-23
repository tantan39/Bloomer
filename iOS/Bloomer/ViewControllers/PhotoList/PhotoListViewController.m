//
//  PhotoListViewController.m
//  Bloomer
//
//  Created by Steven on 3/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PostCell.h"
#import <UIImageView+AFNetworking.h>
#import "out_content_post.h"
#import "TabBarView.h"
#import "AppDelegate.h"
#import "AppHelper.h"
#import "UserDefaultManager.h"
#import "FlowerMenuPostPopupViewController.h"

#define LIMIT 10

@interface PhotoListViewController ()<PostCellDelegate>

@property (strong, nonatomic) TabBarView *tabBar;
@property (strong, nonatomic) AwesomeMenu *circularMenu;
@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) NSIndexPath *droppedIndexPath;
@property (strong, nonatomic) FlowerMenuPostPopupViewController *flowerPopup;
@property (strong, nonatomic) NSTimer *closeThankYouViewTimer;
@property (strong, nonatomic) NSMutableArray *dropLocationViews;
@property (strong, nonatomic) NSString *lastPostID;
@property (strong, nonatomic) UIAlertView *unF;

@end

@implementation PhotoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigationBar];
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [self.userDefaultManager getUserProfileData];
    self.dropLocationViews = [[NSMutableArray alloc] init];
    self.tabBar = ((AppDelegate*)[UIApplication sharedApplication].delegate).tabbar;
    if(self.postsData && self.postsData.count > 0) {
        self.lastPostID = ((out_content_post*)[self.postsData lastObject]).post_id;
    } else {
        self.lastPostID = @"";
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:[PostCell nibName] bundle:nil] forCellReuseIdentifier:[PostCell cellIdentifier]];
    
    if (!self.raceKey || [self.raceKey isEqualToString:@""])
    {
        if (self.postIDs == nil)
        {
            [self.tableView reloadData];
            
            if (self.currentIndexPath.row < self.postsData.count)
            {
                [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
            }
        }
        else
        {
            [self loadFeedWithFeedID:self.feed_id];
        }
    }
    else
    {
        __weak __typeof(self)weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadPostsUsingRaceKeyWithPostID:self.lastPostID];
        }];
        [self loadPostsUsingRaceKeyWithPostID:@""];
    }
    
    __weak __typeof(self)weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf pullToRefresh];
    }];
    
    if(self.status == RACE_CLOSED || self.status == RACE_LEFT)
    {
        [self.topInfoCloseView setHidden:false];
        self.topInfoCloseView.layer.masksToBounds = NO;
        self.topInfoCloseView.layer.shadowOffset = CGSizeMake(0, 1);
        self.topInfoCloseView.layer.shadowRadius = 2;
        self.topInfoCloseView.layer.shadowOpacity = 0.5;
        self.topInfoCloseView.layer.frame = self.topInfoCloseView.frame;
        
        if(self.status == RACE_CLOSED) {
            self.titleForCloseLeaderboard.text = NSLocalizedString(@"RaceHadEndContent.title", );
        } else {
            self.titleForCloseLeaderboard.text = NSLocalizedString(@"UserLeftRaceContent.title", );
        }
    }
    else
    {
        [self.topInfoCloseView setHidden:true];
        
        NSLayoutConstraint* NewTableCostraint = [NSLayoutConstraint constraintWithItem:_tableView
                                                                             attribute:NSLayoutAttributeTop
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.view
                                                                             attribute:NSLayoutAttributeTop
                                                                            multiplier:1
                                                                              constant:0];
        [self.view addConstraint:NewTableCostraint];
        [self.view layoutIfNeeded];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (SEDraggableLocation *dropLocation in self.dropLocationViews)
    {
        [self.tabBar.draggableButton addAllowedDropLocation:dropLocation];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    for (SEDraggableLocation *dropLocation in self.dropLocationViews)
    {
        [self.tabBar.draggableButton removeAllowedDropLocation:dropLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Inititalize

- (void)initNavigationBar
{
    if (![self.raceKey isEqualToString:@""])
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:self.raceName];
    }
    else
    {
        [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Photos", nil)];
    }    
}

-(void)pullToRefresh {
    if (!self.raceKey || [self.raceKey isEqualToString:@""]) {
        [self loadFeedWithFeedID:self.feed_id];
    } else {
//        [self.postsData removeAllObjects];
        self.lastPostID = @"";
        [self loadPostsUsingRaceKeyWithPostID:@""];
    }
}

- (void)giveFlowerPost:(long long)flower postID:(NSString*)postID receiverID:(NSInteger)receiverID
{
    flower_give_post *params = [[flower_give_post alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] num_flower:flower postID:postID receiver:receiverID];
    if (params) {
        API_Flower_GivePost *api = [[API_Flower_GivePost alloc] initWithParams:params];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            out_flower_give * data = (out_flower_give *) jsonObject;
            if (response.status)
            {
                
                [self.userDefaultManager didTutorialGiveFlowerRace:true];
                [self processAfterGivingFlower:data];
                [data showFlowerGivingPopupIn:[UIApplication sharedApplication].keyWindow];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            
        }];
    }

}

- (void)processAfterGivingFlower:(out_flower_give *)data
{
    PostCell *cell = (PostCell *)[self.tableView cellForRowAtIndexPath:self.droppedIndexPath];
    
    [cell showThankYouView:true];
    
    self.closeThankYouViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(removeThankYouView:) userInfo:@{@"IndexPath" : self.droppedIndexPath} repeats:NO];
    
    self.profileData = [self.userDefaultManager getUserProfileData];
    self.profileData.your_num_flower = data.mFlower;
    [self.userDefaultManager saveUserProfileData:self.profileData];
    [self.tabBar updateFlowerValue];

    out_content_post *postData = (out_content_post*)[self.postsData objectAtIndex:self.droppedIndexPath.row];
    postData.mygiveflower = data.mygiveFlower;
    postData.flower = data.flower_onpost;

    if (postData.mygiveflower == -1)
    {
        cell.iconGivedFlowerPhoto.hidden = true;
    }
    else
    {
        cell.iconGivedFlowerPhoto.hidden = false;
    }
    
    UIViewController *previousViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
    if ([previousViewController isKindOfClass:[PicturesRaceViewController class]])
    {
        PicturesRaceViewController *viewController = (PicturesRaceViewController*)previousViewController;
        [viewController.collectionView reloadData];
    }
    
    if (data.bonus_flower > 0)
    {
        [AppHelper showMatchingFlowerPopUp:data.bonus_flower];
    }
}

- (void) loadFeedWithFeedID:(NSString *) feedID{
    if (feedID) {
        API_GetFeed * api = [[API_GetFeed alloc] initWithAccessToken:[_userDefaultManager getAccessToken] DeviceToken:[_userDefaultManager getDeviceToken] FeedID:feedID];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [self.tableView.pullToRefreshView stopAnimating];
            if (response.status) {
                JSON_GetFeed * data = (JSON_GetFeed *) jsonObject;
                self.postsData = data.posts;
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
            }else{
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [self.tableView.pullToRefreshView stopAnimating];
        }];
    }
}

- (void)loadPostsUsingRaceKeyWithPostID:(NSString*)postID
{
    API_UserRacePosts *api = [[API_UserRacePosts alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] key:self.raceKey uid:self.uid post_id:postID limit:LIMIT];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_UserRacePosts * data = (JSON_UserRacePosts *) jsonObject;
        if (response.status)
        {
            if (data.posts.count > 0)
            {
                if ([self.lastPostID isEqualToString:@""])
                {
                    self.postsData = data.posts;
                    [self.tableView reloadData];
                    
                    [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
                }
                else
                {
                    [self.postsData addObjectsFromArray:data.posts];
                    [self.tableView reloadData];
                }
                
                self.lastPostID = ((out_content_post*)data.posts.lastObject).post_id;
            }
        }else{
            [AppHelper showMessageBox:nil message:response.message];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)deletePostAtIndex:(NSInteger) index{
    [self.tableView beginUpdates];
    [self.postsData removeObjectAtIndex:index];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    PicturesRaceViewController *pictureRacesVC = (PicturesRaceViewController*)self.parentView;
    if (pictureRacesVC && self.postsData.count > 0) {
        [pictureRacesVC deletePhotoAtIndex:index];
    }
}

// MARK: - UITableViewDelegate, UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:[PostCell cellIdentifier] forIndexPath:indexPath];
    out_content_post *postData = [self.postsData objectAtIndex:indexPath.row];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:postData.photo_url]];
    [cell.photo setImageWithURLRequest:request placeholderImage:nil
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  cell.photo.image = image;
                              } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                  
                              }];

    [cell bindData:postData];
    cell.parentViewController = self;
    cell.navigationController = self.navigationController;
    cell.delegate = self;
    cell.indexForEdit = indexPath.row;
    
    cell.draggableLocation.index = indexPath;
    cell.draggableLocation.delegate = self;
    
    [AppHelper configureDraggableLocation:cell.draggableLocation objectSize:self.tabBar.draggableButton.frame.size isCircle:false hightlight:false highlightColor:nil];
    
    if (![self.dropLocationViews containsObject:cell.draggableLocation])
    {
        [self.tabBar.draggableButton addAllowedDropLocation:cell.draggableLocation];
        [self.dropLocationViews addObject:cell.draggableLocation];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PostCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    out_content_post *postData = [self.postsData objectAtIndex:indexPath.row];
    
    FullPictureViewController *view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
    
    gallery* gallerypost = [[gallery alloc]init];
    gallerypost.post_id = postData.post_id;
    gallerypost.photo_url = postData.photo_url;
    
    view.post_id = postData.post_id;
    view.isScrollingEnabled = FALSE;
    view.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
    view.currentIndex = 0;
    view.raceName = self.raceName;
    view.parentView = self;
    
    if (self.profileData.uid == postData.uid)
    {
        view.hidesBottomBarWhenPushed = TRUE;
    }
    
    [self.navigationController pushViewController:view animated:TRUE];
}

// MARK: - SEDraggableLocationDelegate

- (void) draggableLocation:(SEDraggableLocation *)location didRefuseObject:(SEDraggable *)object entryMethod:(SEDraggableLocationEntryMethod)method
{
    [object setHidden:true];
    if (self.circularMenu != nil)
    {
        [self.circularMenu removeFromSuperview];
    }
    
    PostCell *cell = (PostCell*)[self.tableView cellForRowAtIndexPath:location.index];
    
    CGPoint startPoint = CGPointMake(UIScreen.mainScreen.bounds.size.width / 2, cell.frame.origin.y + UIScreen.mainScreen.bounds.size.width / 2);
    
    self.circularMenu = [AppHelper createCircularMenuWithFrame:cell.bounds startPoint:startPoint delegate:self];
    self.droppedIndexPath = location.index;

    [self.tableView addSubview:self.circularMenu];
}

// MARK: - AwesomeMenuDelegate

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    [menu removeFromSuperview];
    
    out_content_post *postData = [self.postsData objectAtIndex:self.droppedIndexPath.row];
    
    if (idx < 3 && idx > -1)
    {
        NSInteger nFlower = 0;
        
        switch (idx)
        {
            case 0:
                nFlower = FIRST_FLOWER_BUTTON_VALUE;
                break;
            case 1:
                nFlower = SECOND_FLOWER_BUTTON_VALUE;
                break;
            case 2:
                nFlower = THIRD_FLOWER_BUTTON_VALUE;
                break;
        }
        
        [self giveFlowerPost:nFlower postID:postData.post_id receiverID:postData.uid];
    }
    else
    {
        if (idx == 3)
        {
            self.flowerPopup = [[FlowerMenuPostPopupViewController alloc] initWithNibName:@"FlowerMenuPopUpViewController" bundle:nil];
            self.flowerPopup.postID = postData.post_id;
            self.flowerPopup.uid = postData.uid;
            self.flowerPopup.parentView = self;
            self.flowerPopup.isFirstRank = FALSE;
            
            [self.flowerPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
        }
        else
        {
            if (idx == 4 || idx == -1)
            {
                FlowerGardenViewController *view = [[FlowerGardenViewController alloc] initWithNibName:@"FlowerGardenViewController" bundle:nil];
                view.hidesBottomBarWhenPushed = TRUE;
                
                [self.tabBar snapbackFlowerIconToTabbar];
                [self.navigationController pushViewController:view animated:TRUE];
            }
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([[touch view] isKindOfClass:[AwesomeMenuItem class]])
    {
        return NO;
    }
    else
    {
        [self.circularMenu removeFromSuperview];
        
        return YES;
    }
}

// MARK: - Selectors
- (void)removeThankYouView:(NSTimer*)timer
{
    NSIndexPath *indexPath = (NSIndexPath*)timer.userInfo[@"IndexPath"];
    PostCell *cell = (PostCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell showThankYouView:false];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void) changeDataAfterEdit:(NSString*) title index:(NSInteger) index
{
    NSString* myNewCaption = [NSString stringWithString:title];
    [(out_content_post *)[self.postsData objectAtIndex:index] setCaption:myNewCaption];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
}

//Tu L (4/20/17): Unfollow user
- (void)touchUnFollow {
    _unF = [[UIAlertView alloc] initWithTitle:nil
                                     message:NSLocalizedString(@"Are you sure you want to unfollow this user?",nil)
                                    delegate:self
                           cancelButtonTitle:NSLocalizedString(@"No",nil)
                           otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [_unF show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _unF) {
        if (buttonIndex == 1) {
            block_remove *param = [[block_remove alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] uid:_uid];
            if (param) {
                API_UnFollow *api = [[API_UnFollow alloc] initWithParams:param];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        
                        [AppHelper showMessageBox:nil message:NSLocalizedString(@"InfoUsersSuccessFollow.title",nil)];
                        
                        //Update isFollow property
                        for (out_content_post * post in self.postsData) {
                            [post setIs_follow:NO];
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
    }
}

//MARK: - PostCellDelegate
- (void)deletePostCellWithPostID:(NSString *)postID{
    
    for (NSInteger i = 0; i < self.postsData.count; i++)
    {
        out_content_post *postData = (out_content_post*)[self.postsData objectAtIndex:i];
        if ([postData.post_id isEqualToString:postID])
        {
            [self deletePostAtIndex:i];
            
            if (self.postsData.count == 0){
                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MyProfileViewController class]]) {
                        MyProfileViewController * myProfileVC = (MyProfileViewController *) vc;
                        [myProfileVC loadGallery]; //Reload MyProfileViewController gallery races
                        [self.navigationController popToViewController:myProfileVC animated:YES];
                    }
                }
            }else{

                for (UIViewController * vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[MyProfileViewController class]]) {
                        MyProfileViewController * myProfileVC = (MyProfileViewController *) vc;
                        [myProfileVC loadGallery]; //Reload gallery races
                    }
                }
                
            }
            break;
        }
    }
    
}

@end
