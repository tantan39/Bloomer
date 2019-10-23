//
//  RaceInfoPopupView.m
//  Bloomer
//
//  Created by Steven on 11/1/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "RaceInfoPopupView.h"

@interface RaceInfoPopupView () {
    UserDefaultManager *userDefaultManager;
}

@end

@implementation RaceInfoPopupView

- (void)awakeFromNib
{
    [super awakeFromNib];

    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.contentView.layer.cornerRadius = 12;
    self.contentView.clipsToBounds = true;
    
    self.okButton.layer.cornerRadius = self.okButton.frame.size.height / 2;
    self.okButton.clipsToBounds = true;
}

+ (id)createInView:(UIView*)view raceContent:(NSString*)raceContent raceName:(NSString*)raceName endTime:(NSString*)endTime
{
    RaceInfoPopupView *popupView = [[NSBundle mainBundle] loadNibNamed:@"RaceInfoPopupView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    
    popupView.raceContent = raceContent;
    popupView.raceNames = raceName;
    popupView.endTimes = endTime;
    popupView.leaderboardContent.delegate = popupView;
    
    [popupView initHeightForSpecificDevices];
    [popupView loadLeaderboardContent];
    
    return popupView;
}

- (void)initHeightForSpecificDevices
{
    if (IS_IPHONE_X || IS_IPHONE_PLUS)
    {
        CGFloat multiplier = IS_IPHONE_X ? 0.6 : 0.72;
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.popupViewEqualHeightConstraint.firstItem attribute:self.popupViewEqualHeightConstraint.firstAttribute relatedBy:self.popupViewEqualHeightConstraint.relation toItem:self.popupViewEqualHeightConstraint.secondItem attribute:self.popupViewEqualHeightConstraint.secondAttribute multiplier:multiplier constant:0];
        
        [self removeConstraint:self.popupViewEqualHeightConstraint];
        self.popupViewEqualHeightConstraint = newConstraint;
        [self addConstraint:newConstraint];
        [self layoutIfNeeded];
    }
    else
    {
        CGFloat multiplier = (2.0 / 3.0) + (48.0 / UIScreen.mainScreen.bounds.size.height);
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.popupViewEqualHeightConstraint.firstItem attribute:self.popupViewEqualHeightConstraint.firstAttribute relatedBy:self.popupViewEqualHeightConstraint.relation toItem:self.popupViewEqualHeightConstraint.secondItem attribute:self.popupViewEqualHeightConstraint.secondAttribute multiplier:multiplier constant:0];
        
        [self removeConstraint:self.popupViewEqualHeightConstraint];
        self.popupViewEqualHeightConstraint = newConstraint;
        [self addConstraint:newConstraint];
        [self layoutIfNeeded];
    }
}

-(void) loadLeaderboardContent
{
    NSString *urlString = _raceContent;
    NSString* urlTextEscaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlTextEscaped];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    if (self.leaderboardContent)
    {
        [self.leaderboardContent loadRequest:urlRequest];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error-webview : %@", error);
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    _leaderboardContent.scalesPageToFit = YES;
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom = 1.0;"];
}


- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (([touch view] == _popupView) || ([[touch view] isDescendantOfView:_popupView]) ) {
        return NO;
    } else {
        [self removeAnimate];
    }
    
    return YES;
}

- (IBAction)touchOKButton:(id)sender {
    [self removeAnimate];
}
@end
