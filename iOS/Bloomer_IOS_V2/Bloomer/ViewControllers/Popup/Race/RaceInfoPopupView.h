//
//  RaceInfoPopupView.h
//  Bloomer
//
//  Created by Steven on 11/1/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDefaultManager.h"
#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface RaceInfoPopupView : UIView <UIGestureRecognizerDelegate, UIWebViewDelegate>

+ (id)createInView:(UIView*)view raceContent:(NSString*)raceContent raceName:(NSString*)raceName endTime:(NSString*)endTime;

@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIWebView *leaderboardContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *popupViewEqualHeightConstraint;

- (IBAction)touchOKButton:(id)sender;

@property (weak, nonatomic) NSString *raceContent;
@property (weak, nonatomic) NSString *raceNames;
@property (assign, nonatomic) NSString *endTimes;
@property (weak, nonatomic) UIView *ownerView;

- (void)showWithAnimated:(BOOL)animated;
- (void)removeAnimate;

@end
