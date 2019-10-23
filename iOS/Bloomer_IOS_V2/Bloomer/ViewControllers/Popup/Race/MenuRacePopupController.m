//
//  MenuRacePopupController.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/23/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//


#define JOIN_BUTTON 1
#define SWITCH_BUTTON 2
#define LEAVE_BUTTON 3

#import "MenuRacePopupController.h"
#import "JoinRaceByTopicView.h"
#import "UploadAvatarPopUpView.h"
#import "RaceInfoPopupView.h"

@interface MenuRacePopupController ()
{
    UserDefaultManager *userDefaultManager;
    LeavingRacePopUpViewController *leavePopup;
    JoinInfoPopupViewController *popupInfoJoin;
    JoinRaceByTopicView *  joinRaceView;
    ImagePickerRaceViewController* popupJoin;
    NSInteger switchKey;
}

@end

@implementation MenuRacePopupController

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
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    NSString* ChangeStateString = @"";
    NSString* infoButtonTittle = NSLocalizedString(@"LeaderBoardInfo.tittle", );
    NSString* viewMyRankButtonTitle = NSLocalizedString(@"View My Rank", );
    NSString* viewTop = NSLocalizedString(@"View Contest Top", );
    NSString* cancelButtonTitle = NSLocalizedString(@"CancelPopupRace.title", );
    
    if(_gender == [userDefaultManager getGender]) {
        if (!_isJoin) {
            [_ChangeStateBut setBackgroundColor:UIColorFromRGB(0x4a8ce2)];
            if(_categoryType == RACECATEGORY_LOCATION) {// join a location
                
                ChangeStateString = NSLocalizedString(@"SwitchToALeaderboard.tittle",nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchLeaderBoardInfo:nil];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:ChangeStateString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchChangeState:nil];
                }]];
                
                [self.parentView presentViewController:alertController animated:YES completion:nil];
                
                switchKey = SWITCH_BUTTON;
            } else if(_categoryType == RACECATEGORY_COUNTRY || _categoryType == RACECATEGORY_EVENT) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                
                if(self.userHasRank && !_isViewRaceTop)
                    [alertController addAction:[UIAlertAction actionWithTitle:viewMyRankButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                else
                    [alertController addAction:[UIAlertAction actionWithTitle:viewTop style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchLeaderBoardInfo:nil];
                }]];
                
                [self.parentView presentViewController:alertController animated:YES completion:nil];
                
            } else {// joint a race
                /*if(_categoryType == RACECATEGORY_COUNTRY){ // Country
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                    [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchLeaderBoardInfo:nil];
                    }]];
                    
                    [self.parentView presentViewController:alertController animated:YES completion:nil];
                    
                } else {*/

                ChangeStateString = NSLocalizedString(@"Join this contest",nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchLeaderBoardInfo:nil];
                }]];
                
                if (_categoryType != RACECATEGORY_SPONSOR) {
                    [alertController addAction:[UIAlertAction actionWithTitle:ChangeStateString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchChangeState:nil];
                    }]];
                    switchKey = JOIN_BUTTON;
                }
                [self.parentView presentViewController:alertController animated:YES completion:nil];
                
                //}
            }
        } else {
            if(_categoryType == RACECATEGORY_LOCATION || _categoryType == RACECATEGORY_EVENT) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                
                if(self.userHasRank && !_isViewRaceTop)
                    [alertController addAction:[UIAlertAction actionWithTitle:viewMyRankButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                else
                    [alertController addAction:[UIAlertAction actionWithTitle:viewTop style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchLeaderBoardInfo:nil];
                }]];
                
                [self.parentView presentViewController:alertController animated:YES completion:nil];
                
            } else {
                ChangeStateString = NSLocalizedString(@"LeaveLeaderBoard.tittle",nil);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
                
                if(self.userHasRank && !_isViewRaceTop)
                    [alertController addAction:[UIAlertAction actionWithTitle:viewMyRankButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                else
                    [alertController addAction:[UIAlertAction actionWithTitle:viewTop style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self TouchViewRank:nil];
                    }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchLeaderBoardInfo:nil];
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:ChangeStateString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self TouchChangeState:nil];
                }]];
                
                [self.parentView presentViewController:alertController animated:YES completion:nil];
                
                switchKey = LEAVE_BUTTON;
            }
        }
    }
    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:viewTop style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self TouchViewRank:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:infoButtonTittle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self TouchLeaderBoardInfo:nil];
        }]];
        
        [self.parentView presentViewController:alertController animated:YES completion:nil];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self.view addGestureRecognizer:tap];
    [self removeAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) deleteChangeStateButton
{
    _SearchToBottomContraint = [NSLayoutConstraint constraintWithItem:_CancelBut
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_SearchBut
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:9];
    [self.view addConstraint:_SearchToBottomContraint];
    [self.view layoutIfNeeded];
    [_ChangeStateBut setHidden:true];
}


#pragma mark - Handle Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0: //Open Gallery
            //            [self showPhotoGallery];
            [self TouchLeaderBoardInfo:nil];
            break;
            
        case 2: //Open Camera
            //            [self openCamera];
            [self TouchChangeState:nil];
            break;
        case 1:
            //view my rank
            [self TouchViewRank:nil];
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self removeAnimate];
}



- (void)showAnimate
{
    //    self.view.alpha = 0;
    ////    self.LastestPhotoBut.alpha = 0.0;
    ////    self.LeaderboardInfoBut.alpha = 0.0;
    ////    self.MyRankBut.alpha = 0.0;
    ////    self.SearchBut.alpha = 0.0;
    ////    self.CancelBut.alpha = 0.0;
    ////
    ////    CGRect lastestButRect = _LastestPhotoBut.frame;
    ////    CGRect InfoButRect = _LeaderboardInfoBut.frame;
    ////    CGRect RankButRect = _LastestPhotoBut.frame;
    ////    CGRect SearchButRect = _LastestPhotoBut.frame;
    //    CGRect CancelButRect = _LastestPhotoBut.frame;
    //    CGRect ChangeStateButRect = _LastestPhotoBut.frame;
    ////
    ////    CGRect newLastestButRect = lastestButRect;
    ////    newLastestButRect.origin.x += 5.0;
    ////
    ////    CGRect newInfoButRect = InfoButRect;
    ////    newInfoButRect.origin.x += 10.0;
    ////
    ////    CGRect newRankButRect = RankButRect;
    ////    newRankButRect.origin.x += 15.0;
    ////
    ////    CGRect newSearchButRect = SearchButRect;
    ////    newSearchButRect.origin.x += 20.0;
    ////
    ////    CGRect newCancelButRect = CancelButRect;
    ////    newCancelButRect.origin.x += 25.0;
    ////
    ////    CGRect newChangeStateButRect = ChangeStateButRect;
    ////    newChangeStateButRect.origin.x += 30.0;
    ////
    ////    [self.LastestPhotoBut setFrame:newLastestButRect];
    ////    [self.LeaderboardInfoBut setFrame:newInfoButRect];
    ////    [self.MyRankBut setFrame:newRankButRect];
    ////    [self.SearchBut setFrame:newSearchButRect];
    ////
    ////
    //    if([_ChangeStateBut isHidden] == false)
    //    {
    //        self.ChangeStateBut.alpha = 0.0;
    //
    //        CGRect newChangeStateButRect = ChangeStateButRect;
    //        newChangeStateButRect.origin.x += 25.0;
    //
    //        CGRect newCancelButRect = CancelButRect;
    //        newCancelButRect.origin.x += 30.0;
    //
    //        [self.CancelBut setFrame:newCancelButRect];
    //        [self.ChangeStateBut setFrame:newChangeStateButRect];
    //    }
    //    else
    //    {
    ////        CGRect newCancelButRect = CancelButRect;
    ////        newCancelButRect.origin.x += 25.0;
    //
    ////        [self.CancelBut setFrame:newCancelButRect];
    //    }
    //    [UIView animateWithDuration:.1 animations:^{
    //        self.view.alpha = 1;
    //    }];
    ////    [UIView animateWithDuration:.15 animations:^{
    ////        self.LastestPhotoBut.alpha = 1.0;
    ////        [self.LastestPhotoBut setFrame:lastestButRect];
    ////    }];
    ////    [UIView animateWithDuration:.2 animations:^{
    ////        self.LeaderboardInfoBut.alpha = 1.0;
    ////        [self.LeaderboardInfoBut setFrame:InfoButRect];
    ////    }];
    ////    [UIView animateWithDuration:.25 animations:^{
    ////        self.MyRankBut.alpha = 1.0;
    ////        [self.MyRankBut setFrame:RankButRect];
    ////    }];
    ////    [UIView animateWithDuration:.3 animations:^{
    ////        self.SearchBut.alpha = 1.0;
    ////        [self.SearchBut setFrame:SearchButRect];
    ////
    ////    }];
    //    if([_ChangeStateBut isHidden] == false)
    //    {
    //        [UIView animateWithDuration:.35 animations:^{
    //            self.ChangeStateBut.alpha = 1.0;
    //            [self.ChangeStateBut setFrame:ChangeStateButRect];
    //        }];
    ////        [UIView animateWithDuration:.4 animations:^{
    ////            self.CancelBut.alpha = 1.0;
    ////            [self.CancelBut setFrame:CancelButRect];
    ////        }];
    //    }
    ////    else
    ////    {
    ////        [UIView animateWithDuration:.35 animations:^{
    ////            self.CancelBut.alpha = 1.0;
    ////            [self.CancelBut setFrame:CancelButRect];
    ////        }];
    ////    }
    
    
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    //    [UIView animateWithDuration:.25 animations:^{
    //        self.LastestPhotoBut.alpha = 0.0;
    //        self.LeaderboardInfoBut.alpha = 0.0;
    //        self.MyRankBut.alpha = 0.0;
    //        self.SearchBut.alpha = 0.0;
    //        self.CancelBut.alpha = 0.0;
    //        if([_ChangeStateBut isHidden] == false)
    //        {
    //            self.ChangeStateBut.alpha = 0.0;
    //        }
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    //            [UIView animateWithDuration:.1 animations:^{
    //                self.view.alpha = 0.0;
    //            }completion:^(BOOL finished) {
    //                if (finished) {
    //                    [self.view removeFromSuperview];
    //                }
    //            }];
    //
    //        }
    //    }];
    
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

- (void)closePopup {
    [self removeAnimate];
}

- (IBAction)TouchLastesUpload:(id)sender {
    [self removeAnimate];
    PhotosTaggedInRacesViewController *view = [[PhotosTaggedInRacesViewController alloc] initWithNibName:@"PhotosTaggedInRacesViewController" bundle:nil];
    view.raceName = _raceName;
    view.key = _key;
    view.gender = _gender;
    
    [_parentView.navigationController pushViewController:view animated:YES];
}

- (IBAction)TouchLeaderBoardInfo:(id)sender {
    [self removeAnimate];
    
    RaceInfoPopupView *popupView = [RaceInfoPopupView createInView:UIApplication.sharedApplication.delegate.window raceContent:self.raceContent raceName:self.categoryType > RACECATEGORY_LOCATION ? @"" : self.raceName endTime:self.categoryType > RACECATEGORY_LOCATION ? self.endTime : @""];
    [popupView showWithAnimated:true];
}

- (IBAction)TouchViewRank:(id)sender {
    RacesViewController *view = (RacesViewController *)_parentView;
    if (_gender==[userDefaultManager getGender]) {
        if(!_isViewRaceTop)
        {
            [view loadMyRank:YES];
        }
        else
        {
            [view loadRaceTop];
            view.isViewRaceTop = FALSE;
        }
    } else {
        [view loadRaceTop];
        view.isViewRaceTop = FALSE;
        
    }
    [self removeAnimate];
}

- (IBAction)TouchSearch:(id)sender {
    //    if([((AppDelegate*)[UIApplication sharedApplication].delegate).tabbar getLoadingState] == false)
    //    {
    [self removeAnimate];
    RacesViewController *view = (RacesViewController *)_parentView;
    [view.searchBar becomeFirstResponder];
    [view.searchView setHidden:FALSE];
    view.isHideSearchBar = FALSE;
    [view LeftRevealToggle];
    //    }
}
- (IBAction)TouchChangeState:(id)sender {
    
    if(switchKey == LEAVE_BUTTON) // leave
    {
        leavePopup = [[LeavingRacePopUpViewController alloc] initWithNibName:@"LeavingRacePopUpViewController" bundle:nil];
        leavePopup.key = _key;
        leavePopup.parentView = _parentView;
        leavePopup.content = _leaveInfo;
        leavePopup.raceName = _raceName;
        leavePopup.raceTime = _endTime;
        [self removeAnimate];
        
        leavePopup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
        leavePopup.OnRaceLeft = _OnRacejoined;
        [leavePopup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    }
    else if(switchKey == SWITCH_BUTTON)
    {
        [self removeAnimate];
        
        popupInfoJoin = [[JoinInfoPopupViewController alloc] initWithNibName:@"JoinInfoPopupViewController" bundle:nil];
        __weak MenuRacePopupController* weakSelf = self;
        popupInfoJoin.OnRaceJoined = ^{
            if(weakSelf.OnRacejoined != nil)
            weakSelf.OnRacejoined();
        };
        popupInfoJoin.parentView = _parentView;
        popupInfoJoin.key = _key;
        popupInfoJoin.raceNames = _raceName;
        popupInfoJoin.rules = _joineInfo;
        popupInfoJoin.categoryType = _categoryType;
        popupInfoJoin.locationID = _locationID;
        
        if (_categoryType > RACECATEGORY_LOCATION)
            popupInfoJoin.sEndTime = _endTime;
        
        popupInfoJoin.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
        [popupInfoJoin showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
    }
    else if(switchKey == JOIN_BUTTON)
    {
        [self removeAnimate];
        
        [self doCheckJoinRace];
    }
}

- (void)doCheckJoinRace {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_CheckJoinRace *api = [[API_CheckJoinRace alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:self.key];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        if (response.status) {
//            popupJoin = [[ImagePickerRaceViewController alloc] initWithNibName:@"ImagePickerRaceViewController" bundle:nil];
//            popupJoin.hidesBottomBarWhenPushed = TRUE;
//            popupJoin.parentView = _parentView;
//            popupJoin.key = _key;
//            popupJoin.categoryType = self.categoryType;
//            popupJoin.raceName = _raceName;
//            popupJoin.gender = _gender;
//            popupJoin.hidesBottomBarWhenPushed = YES;
//            popupJoin.myNavigationController = self.MyNavigationController;
//            [popupJoin showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
            UploadAvatarPopUpView *uploadAvatarPopUp = [UploadAvatarPopUpView createInView:[[UIApplication sharedApplication] keyWindow] parentView:self.parentView raceKey:self.key category:self.categoryType];
            uploadAvatarPopUp.OnRaceJoined = ^{
                if(self.OnRacejoined != nil)
                    self.OnRacejoined();
            };
            [uploadAvatarPopUp showWithAnimated:true];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:response.message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (IBAction)TouchCancel:(id)sender {
    [self removeAnimate];
    
}

@end
