//
//  MenuRaceViewJoinViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 3/30/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "MenuRaceViewJoinViewController.h"
#import "RaceInfoPopupView.h"

@interface MenuRaceViewJoinViewController () {
    UserDefaultManager *userDefaultManager;
    ImagePickerRaceViewController *popupJoin;
    JoinInfoPopupViewController *popupInfoJoin;
    LeavingRacePopUpViewController *leavePopup;
}

@end

@implementation MenuRaceViewJoinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        if (SYSTEM_VERSION_LESS_THAN(@"7"))
        {
            CGRect frame = self.view.frame;
            frame.size.height += 20;
            self.view.frame = frame;
        }
        if(IS_IPHONE_4)
        {
            CGRect frame = self.view.frame;
            frame.size.height -= DELTA_IPHONE_4;
            self.view.frame = frame;
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    _seeRaceInfoButton.layer.cornerRadius = 20;
    _seeRaceTaggedPhotosButton.layer.cornerRadius = 20;
    _viewMyRank.layer.cornerRadius = 20;
    _searchPeopleButton.layer.cornerRadius = 20;
//    _surpriseMe.layer.cornerRadius = 20;
    _cacncelButton.layer.cornerRadius = 20;
    _joinRace.layer.cornerRadius = 20;
    _leaveRaceButton.layer.cornerRadius = 20;
    
    if (!_isJoin) {
        [_leaveRaceButton setHidden:TRUE];
        [_joinRace setHidden:FALSE];
        [_viewMyRank setTitle:NSLocalizedString(@"View Contest Top",nil) forState:UIControlStateNormal];
//        [_viewMyRank setHidden:TRUE];
//        [_seeRaceTaggedPhotosButton setFrame:CGRectMake(_seeRaceTaggedPhotosButton.frame.origin.x, _seeRaceTaggedPhotosButton.frame.origin.y + _viewMyRank.frame.size.height,
//                                                        _seeRaceTaggedPhotosButton.frame.size.width, _seeRaceTaggedPhotosButton.frame.size.height)];
//        [_seeRaceInfoButton setFrame:CGRectMake(_seeRaceInfoButton.frame.origin.x, _seeRaceInfoButton.frame.origin.y + _viewMyRank.frame.size.height + 5,
//                                                _seeRaceInfoButton.frame.size.width, _seeRaceInfoButton.frame.size.height)];
        
        if(_categoryType == RACECATEGORY_LOCATION) // join a location
            [_joinRace setTitle:NSLocalizedString(@"SwitchToALeaderboard.tittle",nil) forState:UIControlStateNormal];
        else // joint a reace
            [_joinRace setTitle:NSLocalizedString(@"Join this contest",nil) forState:UIControlStateNormal];
        
        
    } else {
        if(_categoryType == RACECATEGORY_LOCATION){ // location remain
            [_leaveRaceButton setHidden:TRUE];
            [_actionContents setFrame:CGRectMake(_actionContents.frame.origin.x, _actionContents.frame.origin.y + _leaveRaceButton.frame.size.height + 5,
                                                 _actionContents.frame.size.width, _actionContents.frame.size.height)];
            
            
        } else {
            [_leaveRaceButton setHidden:FALSE];
            // leave
        }
        
        [_joinRace setHidden:TRUE];
        [_viewMyRank setHidden:FALSE];
    }
    
    if (!_isViewRaceTop && (_gender == [userDefaultManager getGender]) ) {
        [_viewMyRank setTitle:NSLocalizedString(@"View My Rank",nil) forState:UIControlStateNormal];
        
    } else {
        [_viewMyRank setTitle:NSLocalizedString(@"View Contest Top",nil) forState:UIControlStateNormal];
    }
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
        if (animated) {
            [self showAnimate];
        }
    });
}

- (IBAction)touchJoin:(id)sender {
    [self removeAnimate];
    
    popupInfoJoin = [[JoinInfoPopupViewController alloc] initWithNibName:@"JoinInfoPopupViewController" bundle:nil];
    popupInfoJoin.parentView = _parentView;
    popupInfoJoin.key = _key;
    popupInfoJoin.raceNames = _raceName;
    popupInfoJoin.rules = _joineInfo;
    popupInfoJoin.categoryType = _categoryType;
    popupInfoJoin.locationID = _locationID;
    
    if(_categoryType > RACECATEGORY_LOCATION)
        popupInfoJoin.sEndTime = _endTime;
    
    popupInfoJoin.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popupInfoJoin showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)touchCancel:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchSeeRace:(id)sender {
    [self removeAnimate];
    
    RaceInfoPopupView *popupView = [RaceInfoPopupView createInView:UIApplication.sharedApplication.delegate.window raceContent:self.raceInfo raceName:self.raceName endTime:self.categoryType > RACECATEGORY_LOCATION ? self.endTime : @""];
    [popupView showWithAnimated:true];
}

- (IBAction)touchTaggedRace:(id)sender {
    [self removeAnimate];
    PhotosTaggedInRacesViewController *view = [[PhotosTaggedInRacesViewController alloc] initWithNibName:@"PhotosTaggedInRacesViewController" bundle:nil];
    view.raceName = _raceName;
    view.key = _key;
    view.gender = _gender;
    if(_categoryType > RACECATEGORY_LOCATION)
        view.raceDate = _endTime;
    else
        view.raceDate = @"";
    
    [_parentView.navigationController pushViewController:view animated:YES];
}

- (void)closePopup {
    [self removeAnimate];
}

- (IBAction)touchSearch:(id)sender {
    [self removeAnimate];
    RacesViewController *view = (RacesViewController *)_parentView;
    [view.searchBar becomeFirstResponder];
    [view.searchView setHidden:FALSE];
}

- (IBAction)touchSurprise:(id)sender {
    [self removeAnimate];
    RacesViewController *view = (RacesViewController *)_parentView;
    [view loadSurprise];
}

- (IBAction)touchViewMyRank:(id)sender {
    [self removeAnimate];
    RacesViewController *view = (RacesViewController *)_parentView;
    if (!_isViewRaceTop && _gender==[userDefaultManager getGender]) {
        [view loadMyRank:YES];
    } else {
        [view loadRaceTop];
        view.isViewRaceTop = FALSE;
    }
}

- (IBAction)touchLeave:(id)sender {
    leavePopup = [[LeavingRacePopUpViewController alloc] initWithNibName:@"LeavingRacePopUpViewController" bundle:nil];
    leavePopup.key = _key;
    leavePopup.parentView = _parentView;
    leavePopup.content = _leaveInfo;
    leavePopup.raceName = _raceName;
    leavePopup.raceTime = _endTime;
    [self removeAnimate];
    leavePopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [leavePopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}
@end
