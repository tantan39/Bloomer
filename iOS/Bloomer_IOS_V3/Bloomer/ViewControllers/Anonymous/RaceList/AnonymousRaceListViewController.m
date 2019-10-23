//
//  AnonymousRaceListViewController.m
//  Bloomer
//
//  Created by Steven on 5/3/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "AnonymousRaceListViewController.h"
#import "AppHelper.h"
#import "RaceListView.h"
#import "JoinRaceByTopicView.h"
#import "JoinInfoPopupViewController.h"
#import "BrowserViewController.h"
#import "AnonymousLoginPopUpView.h"
#import "AnonymousRacesViewController.h"
#import "API_BannerMarketing.h"
#import "RaceInfoPopUpView.h"

@interface AnonymousRaceListViewController ()
{
    BOOL isAvailable;
    NSMutableArray *listCategory;
    NSMutableDictionary *maleRacesByCategory;
    NSMutableDictionary *femaleRacesByCategory;
    UserDefaultManager *userDefaultManager;
    NSString* currentLocation;
    NSInteger currentGender;
    NSInteger currentPopUp;
    NSString *needToPushRaceKey;
    out_profile_fetch *profileData;
    JoinInfoPopupViewController *joinPopup;
    JoinRaceByTopicView *joinRaceView;
}
@property (strong, nonatomic) NSMutableArray *marketingBanners;
@end

@implementation AnonymousRaceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    profileData = [userDefaultManager getUserProfileData];
    
    listCategory = [[NSMutableArray alloc] init];
    femaleRacesByCategory = [[NSMutableDictionary alloc]init];
    maleRacesByCategory = [[NSMutableDictionary alloc]init];
    currentGender = FEMALE;
    [self setupCollectionView];
    [self initNavigationBar];
    [self loadBannerMarketing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupLanguage];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames GoToSpecificRace] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames TouchJoinButton] object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToSpecificRace:) name:[NotificationNames GoToSpecificRace] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchJoinButton:) name:[NotificationNames TouchJoinButton] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openVideo:) name:[NotificationNames OpenVideo] object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRaceInfoLink:) name:[NotificationNames OpenRaceInfoLink] object:nil];
    
    [self loadAllRaceList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames OpenVideo] object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NotificationNames OpenRaceInfoLink] object:nil];
}

- (void)setupLanguage
{
    [self.buttonFemale setTitle:[AppHelper getLocalizedString:@"RaceList.buttonFemale"] forState:UIControlStateNormal];
    [self.buttonMale setTitle:[AppHelper getLocalizedString:@"RaceList.buttonMale"] forState:UIControlStateNormal];
}

- (void)initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:NSLocalizedString(@"Contests", "")];
}

- (void)setupCollectionView
{
    __weak AnonymousRaceListViewController *weakSelf = self;
    [self.femaleCollectionView addPullToRefreshWithActionHandler:^{
        [weakSelf loadFemaleRaceList];
    }];
    
    [self.maleCollectionView addPullToRefreshWithActionHandler:^{
        [weakSelf loadMaleRaceList];
    }];
    
    [self.femaleCollectionView registerNib:[UINib nibWithNibName:[RaceListHeaderView nibName] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[RaceListHeaderView viewIdentifier]];
    [self.maleCollectionView registerNib:[UINib nibWithNibName:[RaceListHeaderView nibName] bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[RaceListHeaderView viewIdentifier]];
    [self.femaleCollectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
    [self.maleCollectionView registerNib:[UINib nibWithNibName:[RaceListCell nibName] bundle:nil] forCellWithReuseIdentifier:[RaceListCell cellIdentifier]];
}

- (void)reloadAllRaceLists
{
    [self loadAllRaceList];
}

- (NSString *)daySuffixForDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    if(YSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO)
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}

// MARK: - Functions
- (void)animateLine:(CGFloat)x
{
    self.animatedLineLeftMargin.constant = x;

    [UIView animateWithDuration:0.2 animations:^{
        [self.animatedLine layoutIfNeeded];
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)changeStyleForTabBarButton:(UIButton*)button enabled:(BOOL)enabled
{
    if (enabled)
    {
        button.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:13];
    }
    else
    {
        button.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Bold" size:13];
    }
    
    button.enabled = enabled;
}

// MARK: - API Functions
- (void)loadFemaleRaceList
{
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_RaceList *request = [[API_RaceList alloc] initWithGender:0];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if (data.status) {
            JSON_RaceList *model = (JSON_RaceList*)json;
            listCategory = model.categoryList;
            femaleRacesByCategory = model.racesByCategory;
            [self.femaleCollectionView reloadData];
            [self.femaleCollectionView.pullToRefreshView stopAnimating];
        }
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadMaleRaceList
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    API_RaceList *request = [[API_RaceList alloc] initWithGender:1];
    [request getRequest:^(BaseJSON *json, RestfulResponse *data) {
        if(data.status) {
            JSON_RaceList *model = (JSON_RaceList*)json;
            listCategory = [model categoryList];
            maleRacesByCategory = [model racesByCategory];
            [self.maleCollectionView reloadData];
            [self.maleCollectionView.pullToRefreshView stopAnimating];
        }
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)loadAllRaceList
{
    [self loadFemaleRaceList];
    [self loadMaleRaceList];
}

- (void)loadBannerMarketing
{
    __weak AnonymousRaceListViewController *weakSelf = self;
    
    API_BannerMarketing *request = [[API_BannerMarketing alloc] init];
    [request request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status)
        {
            Json_BannerMarketing *model = (Json_BannerMarketing*)jsonObject;
            weakSelf.marketingBanners = model.banners;
            [weakSelf.maleCollectionView reloadData];
            [weakSelf.femaleCollectionView reloadData];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (NSString *) getCurrentDay
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString* day = [NSString stringWithFormat: @"%ld", (long)[components day]];
    NSString* month = [NSString stringWithFormat: @"%ld", (long)[components month]];
    NSString* currentYear = [NSString stringWithFormat: @"%ld", (long)[components year]];
    NSString* result = [[day stringByAppendingString:month] stringByAppendingString:currentYear];
    return result;
}

// MARK: - UICollectionViewDelegate, FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat bannerViewHeight;
    
    if([UIScreen mainScreen].bounds.size.height == 736) { //PLUS Screen
        bannerViewHeight = self.marketingBanners.count != 0 ? 95 : 0;
    } else {
        bannerViewHeight = self.marketingBanners.count != 0 ? 95 : -12;
    }
    
    if (listCategory.count > 0)
    {
        NSString *sponsoredCategory = [listCategory objectAtIndex:3];
        NSMutableArray *sponsoredRaces = [femaleRacesByCategory objectForKey:sponsoredCategory];
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSMutableArray *themedRaces = [femaleRacesByCategory objectForKey:specialityCategory];
        NSString *exclusiveCategory = [listCategory objectAtIndex:4];
        NSMutableArray *exclusiveRaces = [femaleRacesByCategory objectForKey:exclusiveCategory];
        
        if (collectionView == self.maleCollectionView)
        {
            sponsoredRaces = [maleRacesByCategory objectForKey:sponsoredCategory];
            exclusiveRaces = [maleRacesByCategory objectForKey:exclusiveCategory];
        }
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        return CGSizeMake(screenWidth, 675 + (sponsoredRaces.count > 0 ? 30 + sponsoredRaces.count * screenWidth : 0) + (exclusiveRaces.count > 0 ? 10 + 30 + screenWidth * exclusiveRaces.count : 0) + (themedRaces.count > 0 ? 0 : -30));
    }
    else
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        return CGSizeMake(screenWidth, 10 + (screenWidth * 23 / 31) + 200 + 10 + 30 + bannerViewHeight);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RaceListHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[RaceListHeaderView viewIdentifier] forIndexPath:indexPath];
    
    if (listCategory.count > 0)
    {
        NSString *countryCategory = [listCategory objectAtIndex:0];
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSString *locationCategory = [listCategory objectAtIndex:1];
        NSString *sponsoredCategory = [listCategory objectAtIndex:3];
        NSString *exclusiveCategory = [listCategory objectAtIndex:4];
        NSMutableArray *countryRaces = [femaleRacesByCategory objectForKey:countryCategory];
        NSMutableArray *locationRaces = [femaleRacesByCategory objectForKey:locationCategory];
        NSMutableArray *sponsoredRaces = [femaleRacesByCategory objectForKey:sponsoredCategory];
        NSMutableArray *themedRaces = [femaleRacesByCategory objectForKey:specialityCategory];
        NSMutableArray *exclusiveRaces = [femaleRacesByCategory objectForKey:exclusiveCategory];
        
        view.gender = 0;
        
        if (collectionView == self.maleCollectionView)
        {
            countryRaces = [maleRacesByCategory objectForKey:countryCategory];
            locationRaces = [maleRacesByCategory objectForKey:locationCategory];
            sponsoredRaces = [maleRacesByCategory objectForKey:sponsoredCategory];
            exclusiveRaces = [maleRacesByCategory objectForKey:exclusiveCategory];
            view.gender = 1;
        }
        
        races_list *countryRace = (races_list*)[countryRaces objectAtIndex:indexPath.row];
        [view initSliderCountryView:countryRace.countryAvatarList];
        
        races_list *firstLocationRace = (races_list*)[locationRaces firstObject];
        
        view.labelCountryTitle.text = countryRace.name;
        view.labelLocationTitle.text = firstLocationRace.name;
        
        if (countryRace.avatar != nil)
        {
            [view.countryAvatar setImageWithURL:[NSURL URLWithString:countryRace.avatar]];
        }
        else
        {
            view.countryAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
        }
        
        if (firstLocationRace.avatar != nil)
        {
            [view.locationAvatar setImageWithURL:[NSURL URLWithString:firstLocationRace.avatar]];
        }
        else
        {
            view.locationAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
        }
        
        if([firstLocationRace.gift isEqualToString:@""])
        {
            [view.buttonFirstGift setHidden:YES];
        }
        else
        {
            [view.buttonFirstGift setHidden:NO];
        }
        
        if (firstLocationRace.isClosed)
        {
            [view switchActionView:Closed];
        }
        else
        {
            if (firstLocationRace.is_join == RACE_NOT_ALLOW_TO_JOIN )
            {
                [view switchActionView:Closed];
            }
            else
            {
                if (firstLocationRace.is_join == RACE_NOT_JOINED)
                {
                    if (firstLocationRace.category == RACECATEGORY_LOCATION)
                    {
                        [view switchActionView:Switch];
                    }
                    else
                    {
                        [view switchActionView:NotJoined];
                    }
                }
                else // RACE_JOINED
                {
                    [view switchActionView:Joined];
                }
            }
        }
        
        if (locationRaces.count > 1)
        {
            if (locationRaces.count == 2)
            {
                view.moreLocationView.hidden = true;
                view.secondLocationView.hidden = false;
                
                races_list *secondLocationRace = (races_list*)[locationRaces objectAtIndex:1];
                view.secondLabelLocationTitle.text = secondLocationRace.name;
                
                if (secondLocationRace.avatar != nil)
                {
                    [view.secondLocationAvatar setImageWithURL:[NSURL URLWithString:secondLocationRace.avatar]];
                }
                else
                {
                    view.secondLocationAvatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
                }
                
                if([secondLocationRace.gift isEqualToString:@""])
                {
                    [view.buttonSecondGift setHidden:YES];
                }
                else
                {
                    [view.buttonSecondGift setHidden:NO];
                }
                
                if (secondLocationRace.isClosed)
                {
                    [view switchSecondActionView:Closed];
                }
                else
                {
                    if (secondLocationRace.is_join == RACE_NOT_ALLOW_TO_JOIN )
                    {
                        [view switchSecondActionView:Closed];
                    }
                    else
                    {
                        if (secondLocationRace.is_join == RACE_NOT_JOINED)
                        {
                            if (secondLocationRace.category == RACECATEGORY_LOCATION)
                            {
                                [view switchSecondActionView:Switch];
                            }
                            else
                            {
                                [view switchSecondActionView:NotJoined];
                            }
                        }
                        else // RACE_JOINED
                        {
                            [view switchSecondActionView:Joined];
                        }
                    }
                }
            }
            else
            {
                view.labelMoreLocationTitle.text = [NSString stringWithFormat:@"+%ld %@", (long)locationRaces.count, [AppHelper getLocalizedString:@"RaceList.moreLocations"]];
                view.moreLocationView.hidden = false;
                view.secondLocationView.hidden = true;
            }
        }
        else
        {
            view.moreLocationView.hidden = true;
        }
        
        if (themedRaces.count > 0)
        {
            view.themedViewHeight.constant = 30;
        }
        else
        {
            view.themedViewHeight.constant = 0;
        }
        
        view.countryRaceKey = countryRace.key;
        view.giftForCountry = countryRace.gift;
        if([countryRace.gift isEqualToString:@""])
        {
            [view.buttonCountryGift setHidden:YES];
        }
        else
        {
            [view.buttonCountryGift setHidden:NO];
        }
        view.locationRaces = locationRaces;
        view.sponsoredRaces = sponsoredRaces;
        view.exclusiveRaces = exclusiveRaces;
        view.navigationController = self.navigationController;
        view.parentView = self;
        
        [view setupExclusiveLeaderboards];
        [view setupSponsoredLeaderboards];
        
        view.marketingBanners = self.marketingBanners;
        [view setupMarketingBannersView];
    }
    
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(screenWidth / 2, [RaceListCell cellHeight]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (listCategory.count != 0)
    {
        NSString *specialityCategory = [listCategory objectAtIndex:2];
        NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
        
        if (collectionView == self.maleCollectionView)
        {
            raceList = [maleRacesByCategory objectForKey:specialityCategory];
        }
        
        return raceList.count;
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RaceListCell *cell = (RaceListCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[RaceListCell cellIdentifier] forIndexPath:indexPath];
    
    if (indexPath.row % 2) // odd
    {
        cell.mainViewLeftMargin.constant = 2.5;
    }
    else // even
    {
        cell.mainViewRightMargin.constant = 2.5;
    }
    
    NSString *specialityCategory = [listCategory objectAtIndex:2];
    NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
    
    if (collectionView == self.maleCollectionView)
    {
        raceList = [maleRacesByCategory objectForKey:specialityCategory];
    }
    
    races_list *race = (races_list*)[raceList objectAtIndex:indexPath.row];
    
    cell.labelTitle.text = race.name;
    
    if([race.gift isEqualToString:@""])
    {
        [cell.buttonGift setHidden:YES];
    }
    else
    {
        [cell.buttonGift setHidden:NO];
    }
    
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
        
        cell.raceData = race;
        
        if (collectionView == self.maleCollectionView)
        {
            cell.gender = MALE;
        }
        else
        {
            cell.gender = FEMALE;
        }
        if (race.category > RACECATEGORY_LOCATION)
        {
            cell.labelTime.text = [NSString stringWithFormat:@"%@", race.endDate];
        }
        else
        {
            cell.labelTime.text =@"";
            
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
    NSString *specialityCategory = [listCategory objectAtIndex:2];
    NSMutableArray *raceList = [femaleRacesByCategory objectForKey:specialityCategory];
    
    if (collectionView == self.maleCollectionView)
    {
        raceList = [maleRacesByCategory objectForKey:specialityCategory];
    }
    
    races_list *race = (races_list*)[raceList objectAtIndex:indexPath.row];
    
    if (!race.isClosed)
    {
        AnonymousRacesViewController *view = [[AnonymousRacesViewController alloc] initWithNibName:@"AnonymousRacesViewController" bundle:nil];
        view.key = race.key;
        view.gender = currentGender;
        view.avatarRace = race.avatar;
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:race.closedURL]];
    }
}

// MARK: - Actions
- (IBAction)touchButtonFemale:(id)sender
{
    [self animateLine:self.buttonFemale.frame.origin.x];
    [self.scrollView scrollRectToVisible:CGRectMake(self.femaleCollectionView.frame.origin.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:true];
    currentGender = FEMALE;
    [self changeStyleForTabBarButton:self.buttonFemale enabled:false];
    [self changeStyleForTabBarButton:self.buttonMale enabled:true];
}

- (IBAction)touchButtonMale:(id)sender
{
    [self animateLine:self.buttonMale.frame.origin.x];
    [self.scrollView scrollRectToVisible:CGRectMake(self.maleCollectionView.frame.origin.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:true];
    currentGender = MALE;
    [self changeStyleForTabBarButton:self.buttonFemale enabled:true];
    [self changeStyleForTabBarButton:self.buttonMale enabled:false];
}

// MARK: - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self animateLine:offsetX / 2];
        
        if (offsetX == self.femaleCollectionView.frame.origin.x)
        {
            [self changeStyleForTabBarButton:self.buttonFemale enabled:false];
            [self changeStyleForTabBarButton:self.buttonMale enabled:true];
            currentGender = 0;
        }
        else
        {
            if (offsetX == self.maleCollectionView.frame.origin.x)
            {
                [self changeStyleForTabBarButton:self.buttonFemale enabled:true];
                [self changeStyleForTabBarButton:self.buttonMale enabled:false];
                currentGender = 1;
            }
        }
    }
}

- (void)goToSpecificRace:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSInteger gender = [[userInfo objectForKey:[NotificationKey Gender]] integerValue];
    NSString *key = [userInfo objectForKey:[NotificationKey Key]];
    
    AnonymousRacesViewController *raceViewController = [[AnonymousRacesViewController alloc] initWithNibName:@"AnonymousRacesViewController" bundle:nil];
    raceViewController.key = key;
    raceViewController.gender = gender;
    [self.navigationController pushViewController:raceViewController animated:YES];
}

- (void)touchJoinButton:(NSNotification*)notification
{
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
}

- (void)openVideo:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *videoLink = [userInfo objectForKey:[NotificationKey VideoLink]];
    
    BrowserViewController *browserViewController = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
    browserViewController.urlString = videoLink;
    browserViewController.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:browserViewController animated:true];
}

- (void)openRaceInfoLink:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSString *raceInfoLink = [userInfo objectForKey:[NotificationKey RaceInfoLink]];
    NSString *raceName = [userInfo objectForKey:[NotificationKey RaceName]];
    
    RaceInfoPopupView *popup = [RaceInfoPopupView createInView:UIApplication.sharedApplication.delegate.window raceContent:raceInfoLink raceName:raceName endTime:@""];
    [popup showWithAnimated:true];
}

@end
