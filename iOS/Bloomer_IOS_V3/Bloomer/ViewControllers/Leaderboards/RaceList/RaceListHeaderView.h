//
//  RaceListHeaderView.h
//  Bloomer
//
//  Created by Steven on 12/15/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"
#import "races_list.h"
#import "RaceListCell.h"
#import "API_Profile_Location.h"

@interface RaceListHeaderView : UICollectionReusableView< UIScrollViewDelegate>

// MARK: - Static variables
+ (NSString*) viewIdentifier;
+ (NSString*) nibName;

@property (weak, nonatomic) IBOutlet UIView *countryTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *countryAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelCountryTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCountryViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelThemedViewTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *sliderCountryView;
@property (weak, nonatomic) IBOutlet UIView *countrySliderContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countrySliderContentViewWidth;

@property (strong, nonatomic) IBOutlet UIView *countryContentView;

@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *locationTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *locationAvatar;
@property (weak, nonatomic) IBOutlet UILabel *labelLocationTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iconJoinedRaceLocationView;
@property (weak, nonatomic) IBOutlet UIButton *buttonJoinLocationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionViewWidth;

@property (weak, nonatomic) IBOutlet UIView *secondLocationView;
@property (weak, nonatomic) IBOutlet UIView *secondLocationTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *secondLocationAvatar;
@property (weak, nonatomic) IBOutlet UILabel *secondLabelLocationTitle;
@property (weak, nonatomic) IBOutlet UIImageView *secondIconJoinedRaceLocationView;
@property (weak, nonatomic) IBOutlet UIButton *secondButtonJoinLocationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondActionViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *labelMoreLocationTitle;
@property (weak, nonatomic) IBOutlet UIView *moreLocationTitleView;
@property (weak, nonatomic) IBOutlet UIView *moreLocationView;
@property (weak, nonatomic) IBOutlet UIButton *buttonMore;

@property (weak, nonatomic) IBOutlet UIView *sponsorView;
@property (weak, nonatomic) IBOutlet UILabel *labelSponsorViewTitle;
@property (weak, nonatomic) IBOutlet UIView *sponsorRacesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorRacesViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorTitleViewHeight;
@property (weak, nonatomic) IBOutlet UIView *themedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themedViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *buttonFirstGift;
@property (weak, nonatomic) IBOutlet UIButton *buttonSecondGift;
@property (weak, nonatomic) IBOutlet UIButton *buttonCountryGift;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sponsorTopSpace;

//Exclusive leaderboard
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exclusiveViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exclusiveTitleViewHeight;
@property (strong, nonatomic) IBOutlet UIView *exclusiveRacesView;
@property (strong, nonatomic) IBOutlet UIView *exclusiveRacesBackground;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exclusiveViewTopMargin;
@property (strong, nonatomic) IBOutlet UILabel *exclusiveTitle;

// Marketing Banners
@property (weak, nonatomic) IBOutlet UIView *bannersView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannersViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *bannersScrollView;
@property (weak, nonatomic) IBOutlet UIView *bannersContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannersContentViewWidth;
@property (weak, nonatomic) IBOutlet UIPageControl *bannersPageControl;

- (IBAction)touchButtonCountryView:(id)sender;
- (IBAction)touchButtonLocationView:(id)sender;
- (IBAction)touchButtonMoreLocationView:(id)sender;
- (IBAction)touchButtonJoinLocationView:(id)sender;

@property (weak, nonatomic) NSString *countryRaceKey;
@property (weak, nonatomic) NSMutableArray *locationRaces;
@property (weak, nonatomic) NSMutableArray *sponsoredRaces;
@property (weak, nonatomic) NSMutableArray *exclusiveRaces;
@property (weak, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) UIViewController *parentView;
@property (assign, nonatomic) NSInteger gender;
@property (weak, nonatomic) NSString* giftForCountry;
@property (weak, nonatomic) NSMutableArray *marketingBanners;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeTopSpace;
@property (strong, nonatomic) void (^OnRaceJoined)();

- (IBAction)touchButtonFirstGift:(id)sender;
- (IBAction)touchButtonSecondGift:(id)sender;
- (IBAction)touchButtonGiftLocation:(id)sender;

- (void)switchActionView:(RaceListState)state;
- (void)switchSecondActionView:(RaceListState)state;
- (void)setupSponsoredLeaderboards;
- (void)setupExclusiveLeaderboards;

- (void)initSliderCountryView:(NSArray *) countryAvatars;
- (void)setupMarketingBannersView;

@end
