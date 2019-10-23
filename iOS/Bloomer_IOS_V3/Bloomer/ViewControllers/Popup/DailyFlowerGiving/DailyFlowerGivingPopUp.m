//
//  DailyFlowerGiving.m
//  Bloomer
//
//  Created by Steven on 4/14/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "DailyFlowerGivingPopUp.h"
#import "AppHelper.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"

typedef enum : NSUInteger {
    kPointViewDone = 0,
    kPointViewProcessing = 1,
    kPointViewAvailable = 2,
} PointViewState;

typedef enum : NSUInteger {
    kLineViewDone = 0,
    kLineViewAvailable = 1,
} LineViewState;

typedef enum : NSUInteger {
    kDayLabelDone = 0,
    kDayLabelAvailable = 1,
    kDayLabelDouble = 2,
} DayLabelState;

@implementation DailyFlowerGivingPopUp

+ (id)createStartViewInView:(UIView*)view
{
    DailyFlowerGivingPopUp *popupView = [[NSBundle mainBundle] loadNibNamed:@"DailyFlowerGivingPopUp" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView showWithAnimated:true];
    
    popupView.startView.hidden = false;
    popupView.doubleView.hidden = true;
    popupView.missView.hidden = true;
    popupView.processView.hidden = true;
    
    [popupView initHeightForSpecificDevices];
    [popupView setupLanguage:1];
    
    return popupView;
}

+ (id)createMissViewInView:(UIView*)view
{
    DailyFlowerGivingPopUp *popupView = [[NSBundle mainBundle] loadNibNamed:@"DailyFlowerGivingPopUp" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView showWithAnimated:true];
    
    popupView.startView.hidden = true;
    popupView.doubleView.hidden = true;
    popupView.missView.hidden = false;
    popupView.processView.hidden = true;
    
    [popupView initHeightForSpecificDevices];
    [popupView setupLanguage:1];
    
    return popupView;
}

+ (id)createDoubleViewInView:(UIView*)view
{
    DailyFlowerGivingPopUp *popupView = [[NSBundle mainBundle] loadNibNamed:@"DailyFlowerGivingPopUp" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView showWithAnimated:true];
    
    popupView.startView.hidden = true;
    popupView.doubleView.hidden = false;
    popupView.missView.hidden = true;
    popupView.processView.hidden = true;
    
    [popupView initHeightForSpecificDevices];
    [popupView setupLanguage:1];

    return popupView;
}

+ (id)createProcessViewInView:(UIView*)view finishedDay:(NSInteger)finishedDay
{
    DailyFlowerGivingPopUp *popupView = [[NSBundle mainBundle] loadNibNamed:@"DailyFlowerGivingPopUp" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView showWithAnimated:true];
    
    [popupView initPointsView];
    
    popupView.startView.hidden = true;
    popupView.doubleView.hidden = true;
    popupView.missView.hidden = true;
    popupView.processView.hidden = false;
    
    [popupView finishProcessToDay:finishedDay > 3 ? 3 : finishedDay < 1 ? 1 : finishedDay];
    [popupView initHeightForSpecificDevices];
    [popupView setupLanguage:finishedDay];

    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [self setupLanguage];
    
    self.mainView.layer.cornerRadius = 20;
    self.mainView.clipsToBounds = true;
    
    self.okButton.layer.cornerRadius = self.okButton.frame.size.height / 2;
    self.okButton.clipsToBounds = true;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)setupLanguage:(NSInteger)day
{
    UIFont *boldFont = [UIFont fontWithName:@"SFUIDisplay-Bold" size:12];
    UIColor *color = [UIColor colorFromHexString:@"#333333"];
    NSString *boldText = @"X2 flower matching";
    
    self.processDayLabel.text = [NSString stringWithFormat:@"%@ %ld", [AppHelper getLocalizedString:@"dailyGivingFlower.day"], day];
    self.processCompleteLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.processCompleteLabel"];
    
    if (day == 1)
    {
        self.processTitleLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.processTitleLabel1"];
    }
    else
    {
        self.processTitleLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.processTitleLabel2"];
    }
    
    if (day == 3)
    {
        self.processMessageLabel.attributedText = [AppHelper makeBoldText:boldText inString:[AppHelper getLocalizedString:@"dailyGivingFlower.processMessageLabel2"] font:boldFont color:color];
    }
    else
    {
        self.processMessageLabel.attributedText = [AppHelper makeBoldText:boldText inString:[AppHelper getLocalizedString:@"dailyGivingFlower.processMessageLabel1"] font:boldFont color:color];
    }
    
    self.doubleTitleLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.doubleTitleLabel"];
    self.doubleMessageLabel.attributedText = [AppHelper makeBoldText:boldText inString:[AppHelper getLocalizedString:@"dailyGivingFlower.doubleMessageLabel"] font:boldFont color:color];
    
    self.missTitleLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.missTitleLabel"];
    self.missMessageLabel.attributedText = [AppHelper makeBoldText:boldText inString:[AppHelper getLocalizedString:@"dailyGivingFlower.missMessageLabel"] font:boldFont color:color];
    
    self.startTitleLabel.text = [AppHelper getLocalizedString:@"dailyGivingFlower.startTitleLabel"];
    self.startMessageLabel.attributedText = [AppHelper makeBoldText:boldText inString:[AppHelper getLocalizedString:@"dailyGivingFlower.startMessageLabel"] font:boldFont color:color];
    
    for (NSInteger i = 0; i < self.dayLabels.count - 1; i++)
    {
        UILabel *label = (UILabel*)self.dayLabels[i];
        label.text = [NSString stringWithFormat:@"%@ %ld", [AppHelper getLocalizedString:@"dailyGivingFlower.day"], i + 1];
    }
}

- (void)initHeightForSpecificDevices
{
    if (IS_IPHONE_X || IS_IPHONE_PLUS || IS_IPHONE_6)
    {
        CGFloat multiplier = (IS_IPHONE_6 || IS_IPHONE_PLUS) ? 0.6 : 0.55;
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.mainViewEqualHeightConstraint.firstItem attribute:self.mainViewEqualHeightConstraint.firstAttribute relatedBy:self.mainViewEqualHeightConstraint.relation toItem:self.mainViewEqualHeightConstraint.secondItem attribute:self.mainViewEqualHeightConstraint.secondAttribute multiplier:multiplier constant:0];
        
        [self removeConstraint:self.mainViewEqualHeightConstraint];
        self.mainViewEqualHeightConstraint = newConstraint;
        [self addConstraint:newConstraint];
        [self layoutIfNeeded];
    }
}

- (void)finishProcessToDay:(NSInteger)day
{
    for (NSInteger i = 0; i < self.pointViews.count; i++)
    {
        if (i <= day - 1)
        {
            [self switchPointView:self.pointViews[i] state:kPointViewDone];
            [self switchDayLabel:self.dayLabels[i] state:kDayLabelDone];
        }
        else if (i == day)
        {
            [self switchPointView:self.pointViews[i] state:kPointViewProcessing];
            
            if (i == self.pointViews.count - 1)
            {
                [self switchDayLabel:self.dayLabels[i] state:kDayLabelDouble];
            }
            else
            {
                [self switchDayLabel:self.dayLabels[i] state:kDayLabelAvailable];
            }
        }
        else
        {
            [self switchPointView:self.pointViews[i] state:kPointViewAvailable];
            [self switchDayLabel:self.dayLabels[i] state:kDayLabelAvailable];
        }
    }
    
    for (NSInteger i = 0; i < self.lineViews.count; i++)
    {
        if (i <= day - 1)
        {
            [self switchLineView:self.lineViews[i] state:kLineViewDone];
        }
        else
        {
            [self switchLineView:self.lineViews[i] state:kLineViewAvailable];
        }
    }
}

- (void)initPointsView
{
    for (UIView *subView in self.pointViews)
    {
        [self initPointView:subView];
    }
}

- (void)initPointView:(UIView*)pointView
{
    for (NSInteger i = 0; i < pointView.subviews.count; i++)
    {
        UIView *subView = pointView.subviews[i];
        
        if (i == 1)
        {
            subView.layer.shadowColor = [[UIColor colorFromHexString:@"#989898"] colorWithAlphaComponent:0.5].CGColor;
            subView.layer.shadowOffset = CGSizeMake(0, 2);
            subView.layer.shadowRadius = 5;
            subView.layer.shadowOpacity = 1;
        }
        
        for (NSInteger j = 0; j < subView.subviews.count; j++)
        {
            UIView *subSubView = subView.subviews[j];
            subSubView.layer.cornerRadius = subSubView.frame.size.height / 2;
            subSubView.clipsToBounds = true;
            
            for (NSInteger k = 0; k < subSubView.subviews.count; k++)
            {
                UIView *subSubSubView = subSubView.subviews[k];
                subSubSubView.layer.cornerRadius = subSubSubView.frame.size.height / 2;
                subSubSubView.clipsToBounds = true;
            }
        }
    }
}

- (void)switchPointView:(UIView*)pointView state:(PointViewState)state
{
    for (NSInteger i = 0; i < pointView.subviews.count; i++)
    {
        UIView *subView = pointView.subviews[i];
        
        if (i == state)
        {
            subView.hidden = false;
        }
        else
        {
            subView.hidden = true;
        }
    }
}

- (void)switchLineView:(UIView*)lineView state:(LineViewState)state
{
    switch (state) {
        case kLineViewDone:
            lineView.backgroundColor = [UIColor colorFromHexString:@"#b10407"];
            break;
            
        case kLineViewAvailable:
            lineView.backgroundColor = [UIColor colorFromHexString:@"#e5e5e5"];
            break;
    }
}

- (void)switchDayLabel:(UILabel*)dayLabel state:(DayLabelState)state
{
    switch (state) {
        case kDayLabelDone:
            dayLabel.textColor = [UIColor colorFromHexString:@"#333333"];
            break;
            
        case kDayLabelAvailable:
            dayLabel.textColor = [UIColor colorFromHexString:@"#d2d2d2"];
            break;
            
        case kDayLabelDouble:
            dayLabel.textColor = [UIColor colorFromHexString:@"#B10407"];
            break;
    }
}

// MARK: - Actions
- (IBAction)touchOKButton:(id)sender
{
    [self removeAnimate];
}

- (IBAction) tapBackground:(UIGestureRecognizer *) gesture{
    [self removeAnimate];
}

// MARK: - Required Functions
- (void)showAnimate
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showWithAnimated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.ownerView addSubview:self];
        [self.ownerView addConstraints:[self getConstraintsWithParent:self.ownerView top:0 bottom:0 left:0 right:0]];
        [self.ownerView layoutIfNeeded];
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

@end
