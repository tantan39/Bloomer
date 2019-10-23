//
//  DailyFlowerGiving.h
//  Bloomer
//
//  Created by Steven on 4/14/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyFlowerGivingPopUp : UIView

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pointViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dayLabels;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewEqualHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *processView;
@property (weak, nonatomic) IBOutlet UILabel *processDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *processCompleteLabel;
@property (weak, nonatomic) IBOutlet UILabel *processTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *processMessageLabel;

@property (weak, nonatomic) IBOutlet UIView *doubleView;
@property (weak, nonatomic) IBOutlet UILabel *doubleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleMessageLabel;

@property (weak, nonatomic) IBOutlet UIView *missView;
@property (weak, nonatomic) IBOutlet UILabel *missTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *missMessageLabel;

@property (weak, nonatomic) IBOutlet UIView *startView;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *startMessageLabel;

- (IBAction)touchOKButton:(id)sender;

@property (weak, nonatomic) UIView *ownerView;

+ (id)createStartViewInView:(UIView*)view;
+ (id)createMissViewInView:(UIView*)view;
+ (id)createDoubleViewInView:(UIView*)view;
+ (id)createProcessViewInView:(UIView*)view finishedDay:(NSInteger)finishedDay;
- (void)showWithAnimated:(BOOL)animated;


@end
