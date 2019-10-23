//
//  HotNewsPopUpView.m
//  Bloomer
//
//  Created by Steven on 4/11/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "HotNewsPopUpView.h"
#import "AppHelper.h"
#import "UIView+Extension.h"

@implementation HotNewsPopUpView

+ (id)createInView:(UIView*)view contentLink:(NSString*)contentLink
{
    HotNewsPopUpView *popupView = [[NSBundle mainBundle] loadNibNamed:@"HotNewsPopUpView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    [popupView.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentLink]]];
    popupView.webView.scalesPageToFit = true;
    [popupView initHeightForSpecificDevices];
    
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.cornerRadius = 12;
    self.contentView.clipsToBounds = true;
    
    self.buttonClose.layer.cornerRadius = self.buttonClose.frame.size.height / 2;
    self.buttonClose.clipsToBounds = true;
//    [self.webView setDelegate:self];
    
//    [self setupLanguage];
}

- (void)initHeightForSpecificDevices
{
    if (IS_IPHONE_X || IS_IPHONE_PLUS)
    {
        CGFloat multiplier = IS_IPHONE_X ? 0.6 : 0.72;
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.mainViewEqualHeightConstraint.firstItem attribute:self.mainViewEqualHeightConstraint.firstAttribute relatedBy:self.mainViewEqualHeightConstraint.relation toItem:self.mainViewEqualHeightConstraint.secondItem attribute:self.mainViewEqualHeightConstraint.secondAttribute multiplier:multiplier constant:0];
        
        [self removeConstraint:self.mainViewEqualHeightConstraint];
        self.mainViewEqualHeightConstraint = newConstraint;
        [self addConstraint:newConstraint];
        [self layoutIfNeeded];
    }
    else
    {
        CGFloat multiplier = (2.0 / 3.0) + (48.0 / UIScreen.mainScreen.bounds.size.height);
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.mainViewEqualHeightConstraint.firstItem attribute:self.mainViewEqualHeightConstraint.firstAttribute relatedBy:self.mainViewEqualHeightConstraint.relation toItem:self.mainViewEqualHeightConstraint.secondItem attribute:self.mainViewEqualHeightConstraint.secondAttribute multiplier:multiplier constant:0];
        
        [self removeConstraint:self.mainViewEqualHeightConstraint];
        self.mainViewEqualHeightConstraint = newConstraint;
        [self addConstraint:newConstraint];
        [self layoutIfNeeded];
    }
}

//- (void)setupLanguage
//{
//    [self.buttonClose setTitle:[AppHelper getLocalizedString:@"PopUpMarketing.buttonClose"] forState:UIControlStateNormal];
//}

// MARK: - Actions

- (IBAction)touchCloseButton:(id)sender
{
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

//#pragma UIWebViewDelegate
//-(void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.buttonClose setHidden:NO];
//}

@end
