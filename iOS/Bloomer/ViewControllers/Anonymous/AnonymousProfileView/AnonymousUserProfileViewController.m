//
//  AnonymousUserProfileViewController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AnonymousUserProfileViewController.h"
#import "AppDelegate.h"
#import "AppHelper.h"

@interface AnonymousUserProfileViewController () {
    UserDefaultManager *userDefaultManager;
    NSMutableArray *bannerList;
    NSMutableArray *listGallery; // list albums
    NSMutableDictionary *listPostGallery; // photos list of album
    out_profile_fetch *profileData;
    CGRect bottomFrame;
    CGRect topFrame;
    NSInteger currentIndex;
    UserProfilePopupViewController *popup;
    FlowerMenuPostPopupViewController *flowerPopup;
    BOOL activeRaces;
    BOOL isShowingChatPopup;
    NSTimer *timer;
    BOOL isBlock;
}

@end

@implementation AnonymousUserProfileViewController
@synthesize post_id;//, flowerPopup;

#pragma mark - View functions
- (void)viewDidLoad {
    [super viewDidLoad];
    isBlock = false;
    // Do any additional setup after loading the view from its nib.
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [[out_profile_fetch alloc] init];
    bannerList = [[NSMutableArray alloc] init];
    listPostGallery = [[NSMutableDictionary alloc]init];
    _tableView.alwaysBounceVertical = TRUE;
    _tableView.bounces = TRUE;
    
    topFrame = CGRectMake(0, 0, 320, 402);
    topFrame.size.height = bottomFrame.origin.y + bottomFrame.size.height;
    [_topView setFrame:topFrame];
    
    _tableView.tableHeaderView = _topView;
    
    currentIndex = 0;
    activeRaces = TRUE;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tabbar = appDelegate.tabbar;
    
    
    _Achievementlabel.text = NSLocalizedString(@"AchievementName.title", );
    _swipeToViewMore.text = NSLocalizedString(@"SwipeLabelLeaderBoard.title", );
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadProfileUsingAPI];
    
    [self.navigationController setNavigationBarHidden:FALSE];
}

#pragma mark - Initialize Functions
- (void)initNavigationBar
{
    UILabel * nameTitleView = [[UILabel alloc] initWithFrame:CGRectZero];
    nameTitleView.backgroundColor = [UIColor clearColor];
    nameTitleView.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:16];
    nameTitleView.textColor = [UIColor whiteColor];
    nameTitleView.text = profileData.username;
    [nameTitleView sizeToFit];
    
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:NAVIGATION_TITLE_FONT_NAME size:10];
    titleView.textColor = [UIColor whiteColor];
    titleView.text =NSLocalizedString(@"Profiles", nil);
    [titleView sizeToFit];
    
    [nameTitleView addSubview:titleView];
    titleView.center = nameTitleView.center;
    [titleView setFrame:CGRectMake(titleView.frame.origin.x, titleView.frame.origin.y + nameTitleView.frame.size.height/2+5, titleView.frame.size.width, titleView.frame.size.height)];
    
    if(isBlock == FALSE)
    {
        self.navigationItem.titleView = nameTitleView;
    }
    else
    {
        self.navigationItem.titleView = nil;
    }
    
    if(!profileData.is_block || isBlock == FALSE){
        UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_LoadRace.png"] style:UIBarButtonItemStylePlain target:self action:@selector(touchInfoButton)];
        
        [infoButton setImageInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:infoButton, nil]];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)initProfile {
    _avatar.layer.borderWidth = 2;
    _avatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.clipsToBounds = YES;
    
    _location.text = profileData.location_name;
    _numberFlower.text = @(profileData.num_received_flower + profileData.flower_thankful).stringValue;
    
    if(profileData.num_received_flower + profileData.flower_thankful <= 1)
    {
        _flowerName.text = NSLocalizedString(@"FLOWERName.Title", );
    }
    else
    {
        _flowerName.text = NSLocalizedString(@"FLOWERSName.Title", );
    }
    
    //chat layout
    if(profileData.is_chat || profileData.remain_flower==0){
        [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat-1"]];
        _ChatLabel.textColor = UIColorFromRGB(0x202021);
    } else {
        [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat_popup"]];
        _ChatLabel.textColor = UIColorFromRGB(0xACACAC);
    }
    
    
    _numReciever.text = @(profileData.following).stringValue;
    if (profileData.following <= 1) {
        _RecieveTitle.text = NSLocalizedString(@"RecieverName.Title", );
    } else {
        _RecieveTitle.text = NSLocalizedString(@"RecieversName.Title", );
    }
    
    
    _numGivers.text = @(profileData.follower).stringValue;
    
    if (profileData.follower <= 1) {
        _GiverTitle.text = NSLocalizedString(@"GiverName.Title", );
    } else {
        _GiverTitle.text = NSLocalizedString(@"GiversName.Title", );
    }
    
    _name.text = profileData.name;
    [_avatar setImageWithURL:[NSURL URLWithString:profileData.avatar]];
    
    _message.numberOfLines = 0;
    
    
    if([profileData.about_me isEqualToString:@""])
    {
        _message.text = profileData.about_me;

        [self.view layoutIfNeeded];
        
        NSInteger myNewHeight = _TopViewImage.frame.size.height + _FlowerNumView.frame.size.height + _ButtonView.frame.size.height + _LineView.frame.size.height + 2;
        
        topFrame = _topView.frame;
        
        
        topFrame.size.height = myNewHeight;
        [_topView setFrame:topFrame];
        
        [self.view layoutIfNeeded];
        
        [_LineView setHidden:true];
    }
    else
    {
        _message.text = profileData.about_me;
        
        [self.view layoutIfNeeded];
        
        NSInteger myNewHeight = _TopViewImage.frame.size.height + _FlowerNumView.frame.size.height + _ButtonView.frame.size.height + _LineView.frame.size.height + _StatusView.frame.size.height + 2;
        
        topFrame = _topView.frame;
        
        topFrame.size.height = myNewHeight;
        [_topView setFrame:topFrame];
        
        [self.view layoutIfNeeded];
        
        _message.textColor = UIColorFromRGB(0x3E3E3E);
        
    }
    
    
    [_message sizeToFit];
    
    _tableView.tableHeaderView = _topView;
    
    [self.WinnerButtonImage setHidden:[profileData.video_link isEqualToString:@""]];
    
    [self initNavigationBar];
}

- (void)initSlideShow {
    [_slideshow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < bannerList.count; i++) {
        BannerObj *temp = (BannerObj *)[bannerList objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, _slideshow.frame.size.height)];
        
        __weak typeof(imageView) weakImageView = imageView;
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:temp.photo_url]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            CGRect croppedRect = CGRectMake(temp.x1, temp.y1, temp.x2 - temp.x1, temp.y2 - temp.y1);
            
            if (!CGRectEqualToRect(croppedRect, CGRectZero))
            {
                UIImage *croppedImage = [AppHelper cropToBounds:image rect:croppedRect];
                weakImageView.image = croppedImage;
            }
            else
            {
                weakImageView.image = image;
            }
            
        } failure:nil];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = TRUE;
        
        [_slideshow addSubview:imageView];
        
        _slideshow.contentSize = CGSizeMake(bannerList.count * 320, _slideshow.frame.size.height);
    }
}
#pragma mark - API functions + Delegate

- (void)loadSlideShowUsingAPI {
    API_Anonymous_Profile_BannerFetches *api = [[API_Anonymous_Profile_BannerFetches alloc] initWithUid:_uid];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            JSON_BannerFetch *data = (JSON_BannerFetch *)jsonObject;
            bannerList = data.bannerList;
            
            if (bannerList.count <= 1) {
                [_swipeToViewMore setHidden:true];
            } else {
                [_swipeToViewMore setHidden:false];
            }
            
            if (bannerList.count != 0) {
                [self initSlideShow];
            }
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
    }];
    
}


- (void)loadProfileUsingAPI
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
//    anonymous_profile_fetch_using *profileAPI = [[anonymous_profile_fetch_using alloc] initWithUserId:[NSString stringWithFormat:@"%ld", (long)_uid]];
//    profileAPI.myDelegate = self;
//    [profileAPI connect];
    
    API_Anonymous_ProfileFetch * api = [[API_Anonymous_ProfileFetch alloc] initWithUserID:[NSString stringWithFormat:@"%ld", (long)_uid]];
    [api getRequest:^(BaseJSON * json, RestfulResponse * objStatus) {
        out_profile_fetch * object = (out_profile_fetch *) json;
        if (objStatus.status)
        {
            isBlock = false;
            profileData = object;
            if(profileData.is_block){
                [self initNavigationBar];
            } else {
                [self initProfile];
                [self loadSlideShowUsingAPI];
                [self loadGallery];
            }
        }
        else
        {
            profileData.is_block = true;
            isBlock = true;
            
            [self initNavigationBar];
            
        }
        [self loadGBS];
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError * error) {
        
    }];
}



- (void)loadGallery {
    API_Anonymous_Profile_Gallery_Fetches *API = [[API_Anonymous_Profile_Gallery_Fetches alloc] initWithUid:_uid];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        out_profile_gallery_fetches * data = (out_profile_gallery_fetches *) jsonObject;
        if (response.status) {
            listGallery = [data galleryList];
            for (profile_gallery* galleryItem in listGallery) {
                [self loadPhotoByRaceKey:galleryItem.key userID:[profileData uid]];
            }
            [_tableView reloadData];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)loadPhotoByRaceKey:(NSString*)key userID:(NSInteger)uID {
    API_Anonymous_Profile_Post_GalleryFetches *api = [[API_Anonymous_Profile_Post_GalleryFetches alloc] initWithKey:key uid:uID post_id:@"" limit:LOAD_GALLERY_MIN_LIMIT];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        JSON_GalleryFetches * data = (JSON_GalleryFetches *) jsonObject;
        if (response.status) {
            [listPostGallery setObject:data.galleryList forKey:key];
            for (int i = 0; i < listGallery.count; i++) {
                if([((profile_gallery*)listGallery[i]).key isEqualToString:key]) {
                    if(data.galleryList.count == 0)
                        [listGallery removeObjectAtIndex:i];
                    break;
                }
            }
            [_tableView reloadData];
        } else {
            [AppHelper showMessageBox:nil message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

//Achievment APIs
- (void)loadAchieveUsingAPI
{

}

#pragma mark - Action Functions
- (void)touchInfoButton
{
    [AppHelper showAnonymousLoginPopUpView];
}

- (IBAction)onSwitchAlbumsAndAchievements:(id)sender{
    currentIndex = ((UIButton*)sender).tag;
    [_tableView reloadData];
    [self reloadTableByCurrentIndex];
}

- (IBAction)touchCurrentRank:(id)sender {
    activeRaces = TRUE;
    _achieveData = _activeAchieveData;
    [_tableView reloadData];
    
}

- (IBAction)touchBestResult:(id)sender {
    activeRaces = FALSE;
    _achieveData = _closedAchieveData;
    [_tableView reloadData];
}

- (IBAction)touchChat:(id)sender {
    [AppHelper showAnonymousLoginPopUpView];
}


#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(currentIndex == 0)
        return listGallery.count;
    else
        return _achieveData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentIndex == 0) {
        NSString *identifier = @"ProfileRaceList";
        ProfileRaceListTableViewCell *cell = (ProfileRaceListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ProfileRaceListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.navigationController = self.navigationController;
        
        profile_gallery *temp = (profile_gallery *)[listGallery objectAtIndex:indexPath.row];
        
        NSMutableArray *photos = (NSMutableArray *)[listPostGallery objectForKey:temp.key];
        
        UILabel *tempLabel = [Support formatLabel:cell.raceName raceName:temp.name status:temp.status];
        NSString* tempString = tempLabel.text;
        cell.raceName.text = tempString;
        cell.status = temp.status;
        cell.key = temp.key;
        cell.uid = _uid;
        
        if (!cell.done) {
            //            [cell loadPhoto];
            [cell loadPhotosByArray:photos];
        }
        
        return cell;
    } else {
        NSString *identifier = @"ProfileAchievementList";
        ProfileAchievementsListTableViewCell *cell = (ProfileAchievementsListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ProfileAchievementsListTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        }
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        
        achievementObject* rankInfo = [_achieveData objectAtIndex:indexPath.row];
        
        if([rankInfo getKey] == 0)
        {
            [cell setUpType0:[rankInfo getName] rank:[rankInfo getData]];
            if(indexPath.row < _achieveData.count-1)
            {
                achievementObject* rankTempInfo = [_achieveData objectAtIndex:indexPath.row + 1];
                if([rankTempInfo getKey] != 0)
                {
                    cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
                }
            }
        }
        else if([rankInfo getKey] == 1)
        {
            [cell setUpType1:[rankInfo getName] flowers:[rankInfo getData]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        else if([rankInfo getKey] == 2)
        {
            [cell setUpType2:[rankInfo getName]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        else if([rankInfo getKey] == 3)
        {
            [cell setUpType3:[rankInfo getName]];
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        
        if (indexPath.row == _achieveData.count-1) {
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentIndex == 0) {
        return 164;
    } else {
        return 40;
    }
}

- (void)loadGBS
{
    if(![profileData.gsb_medal isEqualToString:@""])
    {
        [self.GBSView setHidden:NO];
//        [self.GBSView setHidden:YES];
        if([profileData.gsb_medal isEqualToString:@"B"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Bronze", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"S"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Silver", )];
        }
        else if([profileData.gsb_medal isEqualToString:@"G"])
        {
            self.imageGBS.image = [UIImage imageNamed:NSLocalizedString(@"Icon_Flag_Gold", )];
        }
    }
    else
    {
        [self.GBSView setHidden:YES];
    }
}

#pragma mark - More Functions
-(void) reloadTableByCurrentIndex{
    switch (currentIndex) {
        case 0:
        {
            [_topView setFrame:topFrame];
    
            _tableView.tableHeaderView = _topView;
            [self loadDataBasedOnButtonIndex:0];
            break;
        }
        case 1:
        {
            CGRect topViewFrame = topFrame;
            topViewFrame.size.height = topFrame.size.height + 35;
            [_topView setFrame:topViewFrame];
            
            _tableView.tableHeaderView = _topView;
            [self loadDataBasedOnButtonIndex:3];
            break;
        }
        default:
            break;
    }
    
}

- (void)loadDataBasedOnButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self loadGallery];
            break;
        case 3:
            [self loadAchieveUsingAPI];
            break;
    }
}

#pragma mark - More Functions
-(void)removeUnLockChatPopup{
    [_chatPopupView setHidden:YES];
    [_ChatIcon setImage:[UIImage imageNamed:@"icon_chat_popup"]];
    _ChatLabel.textColor = UIColorFromRGB(0xACACAC);
    isShowingChatPopup = FALSE;
}

- (IBAction)Achievement:(id)sender
{
    [AppHelper showAnonymousLoginPopUpView];
}

- (IBAction)TouchButtonWinner:(id)sender
{
    if([profileData.video_link isEqualToString:@""]) return;
    BrowserViewController *browserview = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserview.urlString = profileData.video_link;
    browserview.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserview animated:true];
}

- (IBAction)BackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
