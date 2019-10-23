//
//  RaceListHeaderView.m
//  Bloomer
//
//  Created by Steven on 12/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "RaceListHeaderView.h"
#import "JoinInfoPopupViewController.h"
#import "RacesViewController.h"
#import "MoreLocationViewController.h"
#import "JoinRaceByTopicView.h"
#import "AppHelper.h"
#import "RaceListView.h"
#import "ExclusiveRaceListView.h"
#import "NotificationHelper.h"
#import "BannerView.h"
#import "BannerMarketing.h"

@interface RaceListHeaderView()
{
    JoinInfoPopupViewController *joinPopup;
    JoinRaceByTopicView *joinRaceView;
    NSString* keyInCell;
    NSMutableArray *sponsoredViews;
    NSMutableArray *exclusiveViews;
    NSTimer * timer;
    NSInteger sliderIndex;
    NSArray * _countryAvatars;
}

@property (strong, nonatomic) NSMutableArray *countrySliderItemViews;
@property (strong, nonatomic) NSMutableArray *marketingBannerViews;
@property (assign, nonatomic) CGFloat sliderWidth;

@end

@implementation RaceListHeaderView
@synthesize sliderCountryView;

+ (NSString*)viewIdentifier
{
    return @"RaceListHeaderView";
}

+ (NSString*)nibName
{
    return @"RaceListHeaderView";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.marketingBannerViews = [[NSMutableArray alloc] init];
    sponsoredViews = [[NSMutableArray alloc] init];
    exclusiveViews = [[NSMutableArray alloc] init];
    
    self.labelCountryViewTitle.text = [AppHelper getLocalizedString:@"RaceList.countryLeaderboards"];
    self.labelThemedViewTitle.text = [AppHelper getLocalizedString:@"RaceList.themedLeaderboards"];
    self.labelSponsorViewTitle.text = [AppHelper getLocalizedString:@"RaceList.sponsoredLeaderboards"];
    self.exclusiveTitle.text = [AppHelper getLocalizedString:@"RaceList.winnerLeaderboards"];
    
    [self.buttonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
    [self.secondButtonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
    [self.buttonMore setTitle:[AppHelper getLocalizedString:@"RaceList.buttonMore"] forState:UIControlStateNormal];
    
    self.countryTitleView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.countryTitleView.layer.borderWidth = 2;
    
    self.locationTitleView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.locationTitleView.layer.borderWidth = 2;
    
    self.secondLocationTitleView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.secondLocationTitleView.layer.borderWidth = 2;
    
    self.moreLocationTitleView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.moreLocationTitleView.layer.borderWidth = 2;
    
    self.buttonMore.layer.cornerRadius = self.buttonMore.frame.size.height / 2;
    self.buttonMore.clipsToBounds = true;
    self.buttonJoinLocationView.layer.cornerRadius = self.buttonJoinLocationView.frame.size.height / 2;
    self.buttonJoinLocationView.clipsToBounds = true;
    self.buttonJoinLocationView.layer.borderColor = [UIColor colorFromHexString:@"#5ED769"].CGColor;
    self.buttonJoinLocationView.layer.borderWidth = 1;
    
    self.secondButtonJoinLocationView.layer.cornerRadius = self.secondButtonJoinLocationView.frame.size.height / 2;
    self.secondButtonJoinLocationView.clipsToBounds = true;
    self.secondButtonJoinLocationView.layer.borderColor = [UIColor colorFromHexString:@"#5ED769"].CGColor;
    self.secondButtonJoinLocationView.layer.borderWidth = 1;
    
    self.locationView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.locationView.layer.borderWidth = 2;
    self.locationView.layer.cornerRadius = 10;
    
    self.secondLocationView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.secondLocationView.layer.borderWidth = 2;
    self.secondLocationView.layer.cornerRadius = 10;
    
    self.countryContentView.layer.borderColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    self.countryContentView.layer.borderWidth = 2;
    self.countryContentView.layer.cornerRadius = 10;
}

- (void) initSliderCountryView:(NSArray *) countryAvatars{
    _countryAvatars = [NSArray arrayWithArray:countryAvatars];
    self.countrySliderItemViews = [[NSMutableArray alloc] init];
    self.sliderCountryView.delegate = self;
    self.sliderCountryView.pagingEnabled = true;
    
    for (UIView *subView in self.countrySliderContentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    self.sliderWidth = UIScreen.mainScreen.bounds.size.width - (5 * 2);
    
    for (NSInteger i = 0; i < countryAvatars.count; i++)
    {
        CountryAvatar *countryAvatar = [countryAvatars objectAtIndex:i];
        CountryAvatarCustomView *itemView = (CountryAvatarCustomView*)[[[NSBundle mainBundle] loadNibNamed:@"CountryAvatarCustomView" owner:self options:nil] objectAtIndex:0];
        itemView.translatesAutoresizingMaskIntoConstraints = false;
        
        if (countryAvatar)
        {
            [itemView setModel:countryAvatar];
        }
        
        [self.countrySliderContentView addSubview: itemView];
        
        if (i == 0)
        {
            [AppHelper setupConstraintsForHorizontalView:itemView previousView:nil isFirstView:true parentView:self.countrySliderContentView width:self.sliderWidth spacing:0];
        }
        else
        {
            CountryAvatarCustomView *previousItemView = (CountryAvatarCustomView*)self.countrySliderItemViews[self.countrySliderItemViews.count - 1];
            [AppHelper setupConstraintsForHorizontalView:itemView previousView:previousItemView isFirstView:false parentView:self.countrySliderContentView width:self.sliderWidth spacing:0];
        }
        
        [self.countrySliderItemViews addObject:itemView];
    }
    
    self.countrySliderContentViewWidth.constant = self.sliderWidth * countryAvatars.count;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnRaceCountrySlider:)];
    tapGesture.cancelsTouchesInView = NO;
    [sliderCountryView addGestureRecognizer:tapGesture];
    
    sliderIndex = 0;
    [timer invalidate];
//    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES] ;
}

- (void) scrollImage
{
    if (sliderIndex == _countryAvatars.count)
    {
        sliderIndex = 0;
        [sliderCountryView setContentOffset:CGPointMake((sliderIndex * self.sliderWidth), 0) animated:NO];
    }
    else
    {
        [sliderCountryView setContentOffset:CGPointMake((sliderIndex * self.sliderWidth), 0) animated:YES];
    }
    sliderIndex++;
}

- (IBAction)touchButtonFirstGift:(id)sender {
    races_list *locationRace = (races_list*)[self.locationRaces objectAtIndex:0];

    [NotificationHelper postNotificationForOpeningRaceInfoLink:locationRace.gift raceName:@""];
}

- (IBAction)touchButtonSecondGift:(id)sender {
    races_list *locationRace = (races_list*)[self.locationRaces objectAtIndex:1];
    
    [NotificationHelper postNotificationForOpeningRaceInfoLink:locationRace.gift raceName:@""];
}

- (IBAction)touchButtonGiftLocation:(id)sender {
    [NotificationHelper postNotificationForOpeningRaceInfoLink:_giftForCountry raceName:@""];
}

- (void)switchActionView:(RaceListState)state
{
    switch (state) {
        case Joined:
            self.iconJoinedRaceLocationView.hidden = false;
            self.buttonJoinLocationView.hidden = true;
            self.actionViewWidth.constant = 50;
            break;
            
        case Switch:
            self.iconJoinedRaceLocationView.hidden = true;
            self.buttonJoinLocationView.hidden = false;
            
            [self.buttonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonSwitch"] forState:UIControlStateNormal];
            
            self.actionViewWidth.constant = 50;
            break;
            
        case NotJoined:
            self.iconJoinedRaceLocationView.hidden = true;
            
            self.buttonJoinLocationView.hidden = false;
            
            [self.buttonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
            
            self.buttonJoinLocationView.hidden = false;
            self.actionViewWidth.constant = 50;
            break;
            
        case Closed:
            self.iconJoinedRaceLocationView.hidden = true;
            self.buttonJoinLocationView.hidden = true;
            self.actionViewWidth.constant = 0;
            break;
    }
}

- (void)switchSecondActionView:(RaceListState)state
{
    switch (state)
    {
        case Joined:
            self.secondIconJoinedRaceLocationView.hidden = false;
            self.secondButtonJoinLocationView.hidden = true;
            self.secondActionViewWidth.constant = 45;
            break;
            
        case Switch:
            self.secondIconJoinedRaceLocationView.hidden = true;
            self.secondButtonJoinLocationView.hidden = false;
            
            [self.secondButtonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonSwitch"] forState:UIControlStateNormal];
            
            self.secondActionViewWidth.constant = 45;
            break;
            
        case NotJoined:
            self.secondIconJoinedRaceLocationView.hidden = true;
            self.secondButtonJoinLocationView.hidden = false;
            
            [self.secondButtonJoinLocationView setTitle:[AppHelper getLocalizedString:@"RaceList.buttonJoin"] forState:UIControlStateNormal];
            
            self.secondActionViewWidth.constant = 45;
            break;
            
        case Closed:
            self.secondIconJoinedRaceLocationView.hidden = true;
            self.secondButtonJoinLocationView.hidden = true;
            self.secondActionViewWidth.constant = 0;
            break;
    }
}

- (void)setupSponsoredLeaderboards
{
    for (UIView* view in sponsoredViews)
    {
        [view removeFromSuperview];
    }
    
    [sponsoredViews removeAllObjects];
    
    if (self.sponsoredRaces.count == 0)
    {
        self.sponsorTitleViewHeight.constant = 0;
        self.sponsorViewHeight.constant = 0;
        self.sponsorRacesViewTopMargin.constant = 0;
//        self.themeTopSpace.constant -= 10;
        self.sponsorTopSpace.constant = 0;
    }
    else
    {
        self.sponsorTopSpace.constant = 10;
        self.sponsorTitleViewHeight.constant = 0; //30
        self.sponsorRacesViewTopMargin.constant = 5; //0
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 0;
        
        for (NSInteger i = 0; i < self.sponsoredRaces.count; i++)
        {
            CGFloat heightScale = 1;
			
            RaceListView *raceListView = (RaceListView*)[[[NSBundle mainBundle] loadNibNamed:@"RaceListView" owner:self options:nil] objectAtIndex:0];
            races_list *race = (races_list*)[self.sponsoredRaces objectAtIndex:i];
            
            raceListView.translatesAutoresizingMaskIntoConstraints = false;
            raceListView.topBannerViewHeight.constant = race.topBannerLink.length ? 100 : 0;
			
            [self.sponsorRacesView addSubview:raceListView];
            [sponsoredViews addObject:raceListView];
			
            if (race.logo.length) {
                heightScale = 23.0 / 31;
                raceListView.logoWidthConstraint.constant = screenWidth / 2;
                [raceListView layoutIfNeeded];
            }
			
			CGFloat topBannerViewHeight = race.topBannerLink.length ? 100 : 0;
			CGFloat viewHeight = (screenWidth * heightScale) + topBannerViewHeight;
            height += viewHeight;
            
            if (i == 0)
            {
                [self setupConstraintsForSponsoredRaceView:raceListView previousView:nil isFirstView:true parentView:self.sponsorRacesView height:viewHeight];
            }
            else
            {
                UIView *previousSponsoredView = [sponsoredViews objectAtIndex: i - 1];
                [self setupConstraintsForSponsoredRaceView:raceListView previousView:previousSponsoredView isFirstView:false parentView:self.sponsorRacesView height:viewHeight];
            }
            
            [self bindDataToView:raceListView race:race];
			
			raceListView.raceData = race;
            raceListView.gender = self.gender;
			
            if([race.gift isEqualToString:@""])
            {
                [raceListView.ButtonGift setHidden:YES];
            }
            else
            {
                [raceListView.ButtonGift setHidden:NO];
            }
        }
        self.sponsorViewHeight.constant = /*30*/ 5 + height;
    }
}

- (void)setupExclusiveLeaderboards
{
    for (UIView* view in exclusiveViews)
    {
        [view removeFromSuperview];
    }
    
    [exclusiveViews removeAllObjects];
    
    if (self.exclusiveRaces.count == 0)
    {
        self.exclusiveTitleViewHeight.constant = 0;
        self.exclusiveViewHeight.constant = 0;
        self.exclusiveViewTopMargin.constant = 0;
//        self.themeTopSpace.constant -= 10;
    }
    else
    {
        self.exclusiveViewTopMargin.constant = 10;
        self.exclusiveTitleViewHeight.constant = 30;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat exclusiveViewHeight = 0;
        for (NSInteger i = 0; i < self.exclusiveRaces.count; i++)
        {
            races_list *race = (races_list*)[self.exclusiveRaces objectAtIndex:i];
            CGFloat heightScale = 1;
			CGFloat topBannerViewHeight = race.topBannerLink.length ? 100 : 0;
			CGFloat viewHeight = (screenWidth * heightScale) + topBannerViewHeight;
            exclusiveViewHeight += viewHeight;
			
            ExclusiveRaceListView *raceListView = (ExclusiveRaceListView*)[[[NSBundle mainBundle] loadNibNamed:@"ExclusiveRaceListView" owner:self options:nil] objectAtIndex:0];
            raceListView.translatesAutoresizingMaskIntoConstraints = false;
			raceListView.topBannerViewHeight.constant = race.topBannerLink.length ? 100 : 0;
			
            [raceListView.avatarHalfWidthConstraints setActive:NO];
            [raceListView.avatarFullWidthConstraint setActive:YES];
            
            [self.exclusiveRacesView addSubview:raceListView];
            [exclusiveViews addObject:raceListView];
            
            if (i == 0)
            {
                [self setupConstraintsForSponsoredRaceView:raceListView previousView:nil isFirstView:true parentView:self.exclusiveRacesView height:viewHeight];
            }
            else
            {
                UIView *previousSponsoredView = [exclusiveViews objectAtIndex: i - 1];
                [self setupConstraintsForSponsoredRaceView:raceListView previousView:previousSponsoredView isFirstView:false parentView:self.exclusiveRacesView height:viewHeight];
            }
            
            [self bindDataToView:raceListView exclusiveRace:race];
            raceListView.raceData = race;
            raceListView.gender = self.gender;
			
            if ([race.gift isEqualToString:@""])
            {
                [raceListView.ButtonGift setHidden:YES];
            }
            else
            {
                [raceListView.ButtonGift setHidden:NO];
            }
            
        }
        self.exclusiveViewHeight.constant = 30 + exclusiveViewHeight;
    }
}

- (void)bindDataToView:(RaceListView*)view race:(races_list*)race
{
    view.labelTitle.text = race.name;
	
	if (race.topBannerLink.length)
	{
		[view.bannerImage setImageWithURL:[NSURL URLWithString:race.topBannerLink]];
	}
	
    if (race.avatar.length)
    {
        [view.avatar setImageWithURL:[NSURL URLWithString:race.avatar]];
    }
    else
    {
        view.avatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if (race.logo.length)
    {
        [view.imageLogo setImageWithURL:[NSURL URLWithString:race.logo]];
    }
    else
    {
        view.imageLogo.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if (race.isClosed || race.end / 1000 <= [[NSDate date] timeIntervalSince1970])
    {
        [view switchActionView:Closed];
        view.labelTime.text = NSLocalizedString(@"Closed",);
    }
    else
    {
        if (race.category > RACECATEGORY_LOCATION)
        {
            view.labelTime.text = [NSString stringWithFormat:@"%@", race.endDate];
        }
        else
        {
            view.labelTime.text =@"";
        }
        
        if (race.is_join == RACE_NOT_ALLOW_TO_JOIN )
        {
            [view switchActionView:Closed];
        }
        else
        {
            if (race.is_join == RACE_NOT_JOINED)
            {
                if (race.category == RACECATEGORY_LOCATION)
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
}

- (void)bindDataToView:(ExclusiveRaceListView*)view exclusiveRace:(races_list*)race
{
    view.labelTitle.text = race.name;
    view.trophyWidthConstraint.constant = 0;
    [view layoutIfNeeded];
    
    switch (race.gsb) {
        case 1:
//            view.trophyImageView.image = [UIImage imageNamed:@"Icon_Trophy_Bronze"];
            self.exclusiveRacesBackground.backgroundColor = [UIColor colorFromHexString:@"#9D7D66"];
            view.labelTitle.textColor = [UIColor colorFromHexString:@"#9D7D66"];
            break;
        case 7:
//            view.trophyImageView.image = [UIImage imageNamed:@"Icon_Trophy_Silver"];
            self.exclusiveRacesBackground.backgroundColor = [UIColor colorFromHexString:@"#898C9D"];
            view.labelTitle.textColor = [UIColor colorFromHexString:@"#898C9D"];
            break;
        case 28:
//            view.trophyImageView.image = [UIImage imageNamed:@"Icon_Trophy_Gold"];
            self.exclusiveRacesBackground.backgroundColor = [UIColor colorFromHexString:@"#E3A91F"];
            view.labelTitle.textColor = [UIColor colorFromHexString:@"#E3A91F"];
            break;
        default:
            view.trophyWidthConstraint.constant = 0;
            [view layoutIfNeeded];
            break;
    }
	
	if (race.topBannerLink.length)
	{
		[view.bannerImage setImageWithURL:[NSURL URLWithString:race.topBannerLink]];
	}
    
    if (race.avatar != nil && race.avatar.length)
    {
        [view.avatar setImageWithURL:[NSURL URLWithString:race.avatar]];
    }
    else
    {
        view.avatar.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if (race.logo.length)
    {
        [view.imageLogo setImageWithURL:[NSURL URLWithString:race.logo]];
    }
    else
    {
        view.imageLogo.image = [UIImage imageNamed:@"Image_Empty_Race"];
    }
    
    if (race.isClosed || race.end / 1000 <= [[NSDate date] timeIntervalSince1970])
    {
        [view switchActionView:Closed];
        view.labelTime.text = NSLocalizedString(@"Closed",);
    }
    else
    {
        if (race.category > RACECATEGORY_LOCATION)
        {
            view.labelTime.text = [NSString stringWithFormat:@"%@", race.endDate];
        }
        else
        {
            view.labelTime.text =@"";
        }
        
        if (race.is_join == RACE_NOT_ALLOW_TO_JOIN )
        {
            [view switchActionView:Closed];
        }
        else
        {
            if (race.is_join == RACE_NOT_JOINED)
            {
                if (race.category == RACECATEGORY_LOCATION)
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
}

- (void)setupMarketingBannersView
{
    CGFloat bannerViewWidth = UIScreen.mainScreen.bounds.size.width - (5 * 2) -(15 * 2);
    
    self.bannersViewHeight.constant = self.marketingBanners.count == 0 ? 0 : 114;
    
    for (NSInteger i = 0; i < self.marketingBanners.count; i++)
    {
        BannerView *bannerView = (BannerView*)[[[NSBundle mainBundle] loadNibNamed:@"BannerView" owner:self options:nil] objectAtIndex:0];
        [bannerView setParentViewController:self.parentView];
        bannerView.translatesAutoresizingMaskIntoConstraints = false;
        
        [self.bannersContentView addSubview:bannerView];
        [self.marketingBannerViews addObject:bannerView];
        
        if (i == 0)
        {
            [self setupConstraintsForBannerView:bannerView parentView:self.bannersContentView isFirstView:true previousView:nil horizontalSpacing:30 firstViewHorizontalSpacing:15 bannerWidth:bannerViewWidth];
        }
        else
        {
            UIView *previousBannerView = [self.marketingBannerViews objectAtIndex:i - 1];
            [self setupConstraintsForBannerView:bannerView parentView:self.bannersContentView isFirstView:false previousView:previousBannerView horizontalSpacing:30 firstViewHorizontalSpacing:15 bannerWidth:bannerViewWidth];
        }
        
        BannerMarketing *bannerMarketing = (BannerMarketing*)[self.marketingBanners objectAtIndex:i];
        
        [bannerView.bannerViewImage setImageWithURL:[NSURL URLWithString:bannerMarketing.bodyLink]];
        bannerView.urlString = bannerMarketing.footLink;
        bannerView.deeplinkUrl = bannerMarketing.headLink;
    }
    
    self.bannersContentViewWidth.constant = (UIScreen.mainScreen.bounds.size.width - (5 * 2)) * self.marketingBanners.count;
    self.bannersScrollView.delegate = self;
    self.bannersPageControl.numberOfPages = self.marketingBanners.count;
}

- (void)setupConstraintsForSponsoredRaceView:(UIView*)view previousView:(UIView*)previousView isFirstView:(BOOL)isFirstView parentView:(UIView*)parentView height:(CGFloat)height
{
    NSLayoutConstraint *topMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    }
    else
    {
        topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    }
    
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [parentView addConstraints:@[topMargin, leftMargin, rightMargin]];
    [view addConstraint:heightConstraint];
}

- (void)setupConstraintsForOneSponsoredRace:(UIView*)view
{
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sponsorRacesView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *leftMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.sponsorRacesView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *rightMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.sponsorRacesView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sponsorRacesView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.sponsorRacesView addConstraints:@[topMargin, leftMargin, rightMargin, bottomMargin]];
}

- (void)setupConstraintsForSponsoredRace:(UIView*)sponsoredRaceView firstView:(UIView*)firstView secondView:(UIView*)secondView
{
    NSLayoutConstraint *firstViewTopMargin = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *firstViewLeftMargin = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
    NSLayoutConstraint *firstViewBottomMargin = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [sponsoredRaceView addConstraints:@[firstViewTopMargin, firstViewLeftMargin, firstViewBottomMargin]];
    
    NSLayoutConstraint *secondViewTopMargin = [NSLayoutConstraint constraintWithItem:secondView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *secondViewRightMargin = [NSLayoutConstraint constraintWithItem:secondView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *secondViewBottomMargin = [NSLayoutConstraint constraintWithItem:secondView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:sponsoredRaceView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *secondViewLeftMargin = [NSLayoutConstraint constraintWithItem:secondView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:firstView attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
    
    [sponsoredRaceView addConstraints:@[secondViewTopMargin, secondViewRightMargin, secondViewBottomMargin, secondViewLeftMargin]];
    
    NSLayoutConstraint *firstViewHeightConstraint = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[RaceListView viewSize].height];
    NSLayoutConstraint *secondViewHeightConstraint = [NSLayoutConstraint constraintWithItem:secondView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[RaceListView viewSize].height];
    NSLayoutConstraint *equalWidthConstraint = [NSLayoutConstraint constraintWithItem:firstView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:secondView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    [firstView addConstraint:firstViewHeightConstraint];
    [secondView addConstraint:secondViewHeightConstraint];
    
    [NSLayoutConstraint activateConstraints:@[equalWidthConstraint]];
}

- (void)setupConstraintsForBannerView:(UIView*)bannerView parentView:(UIView*)parentView isFirstView:(BOOL)isFirstView previousView:(UIView*)previousView horizontalSpacing:(CGFloat)horizontalSpacing firstViewHorizontalSpacing:(CGFloat)firstViewHorizontalSpacing bannerWidth:(CGFloat)bannerWidth
{
    NSLayoutConstraint *leftMargin = [[NSLayoutConstraint alloc] init];
    
    if (isFirstView)
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeft multiplier:1 constant:firstViewHorizontalSpacing];
    }
    else
    {
        leftMargin = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeRight multiplier:1 constant:horizontalSpacing];
    }
    
    NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottomMargin = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bannerWidth];
    
    [bannerView addConstraint:width];
    [parentView addConstraints:@[leftMargin, topMargin, bottomMargin]];
}

// MARK: - Actions
- (void) tapOnRaceCountrySlider:(UIGestureRecognizer *) gesture{
    CGPoint offset = [gesture locationInView:sliderCountryView];
    NSInteger index = (offset.x / sliderCountryView.contentSize.width) * _countryAvatars.count;
    CountryAvatar * banner = nil;
    if (_countryAvatars.count > 0) {
        banner = [_countryAvatars objectAtIndex:index];
    }
    if (banner) {
        [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:self.countryRaceKey timeStampKey:banner.child];
    }
    
}

- (IBAction)touchButtonCountryView:(id)sender
{
    [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:self.countryRaceKey timeStampKey:nil];
}

- (IBAction)touchButtonLocationView:(id)sender
{
    UIButton *button = (UIButton*)sender;
    races_list *locationRace = (races_list*)[self.locationRaces objectAtIndex:button.tag];
    [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:locationRace.key timeStampKey:nil];
}

- (IBAction)touchButtonMoreLocationView:(id)sender {
    MoreLocationViewController *moreLocationViewController = [[MoreLocationViewController alloc] initWithNibName:@"MoreLocationViewController" bundle:nil];
    moreLocationViewController.gender = _gender;
    moreLocationViewController.locationRaces = self.locationRaces;
    moreLocationViewController.myNavigationController = self.navigationController;
    [self.navigationController pushViewController:moreLocationViewController animated:true];
}

-(void)SwitchPopupOK:(NSInteger) locID andKey:(NSString *)myKey
{
    keyInCell = myKey;
    UserDefaultManager *userManager = [(AppDelegate *)[UIApplication sharedApplication].delegate getUserManager];
    location *param = [[location alloc] initWithAccess_Token:[userManager getAccessToken] device_token:[userManager getDeviceToken] locationID:locID];
    if (param) {
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            
            if (response.status)
            {
                //        RacesViewController *view = [[RacesViewController alloc] initWithNibName:@"RacesViewController" bundle:nil];
                //        view.key = keyInCell;
                //        view.gender = _gender;
                //        [self.navigationController pushViewController:view animated:YES];
                [NotificationHelper postNotificationForGoingToSpecificRace:self.gender key:keyInCell timeStampKey:nil];
                [NotificationHelper postNotificationSwitchLocationContestSuccess];
            }
            else
            {
                [AppHelper showMessageBox:nil message:response.message];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }

}


- (IBAction)touchButtonJoinLocationView:(id)sender {
    UIButton *button = (UIButton*)sender;
    races_list *firstLocationRace = (races_list*)[self.locationRaces objectAtIndex:button.tag];
    
    joinPopup = [[JoinInfoPopupViewController alloc] initWithNibName:@"JoinInfoPopupViewController" bundle:nil];
    __weak RaceListHeaderView* weakSelf = self;
    joinPopup.OnRaceJoined = ^{
        if(weakSelf.OnRaceJoined != nil)
            weakSelf.OnRaceJoined();
    };
    joinPopup.key = firstLocationRace.key;
    joinPopup.parentView = self.parentView;
    joinPopup.raceNames = firstLocationRace.name;
    joinPopup.locationID = firstLocationRace.locationID;
    joinPopup.categoryType = firstLocationRace.category;
    joinPopup.rules = firstLocationRace.joinInfo;
    joinPopup.sEndTime = firstLocationRace.endDate;
    
    joinPopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [joinPopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    [joinPopup showInView:nil withCompletionHandler:^(NSString *buttonTitle, NSInteger locationID) {
        [self SwitchPopupOK:locationID andKey:firstLocationRace.key];
    }];
}

//MARK: - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.sliderCountryView)
    {
        CGPoint point  = scrollView.contentOffset;
        sliderIndex = ((point.x / scrollView.contentSize.width) * _countryAvatars.count) + 1;
        
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.sliderCountryView)
    {
        [timer invalidate];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bannersScrollView)
    {
        CGFloat x = scrollView.contentOffset.x;
        NSInteger currentIndex = x / self.bannersScrollView.frame.size.width;
        self.bannersPageControl.currentPage = currentIndex;
    }
}

@end
