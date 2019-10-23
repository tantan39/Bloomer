//
//  PopupForGBS.m
//  Bloomer
//
//  Created by Thanh Tu Nguyen on 8/7/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PopupForGSB.h"
#import "UIColor+Extension.h"

@interface PopupForGSB () {
    UIActivityIndicatorView *spinner;
}

@end

@implementation PopupForGSB

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.separateOKButton setTitle:NSLocalizedString(@"WinnersClub.PopupOKTitle",) forState:UIControlStateNormal];
    
    // Setup Default UI
    self.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.popupContentView.layer.cornerRadius = 10;
    self.popupContentView.layer.masksToBounds = true;
    self.separateOKButton.cornerRadius = [NSNumber numberWithFloat:4];
    
    // Setup delegates and gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(removeAnimate)];
    [self.view addGestureRecognizer:tap];
    self.myWebView.delegate = self;
    self.separateOKButton.backgroundColor = [UIColor rgb:180 green:31 blue:36];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *urlString = [[[APIDefine infoGSB] stringByAppendingString:[NSLocalizedString(@"EN",nil) lowercaseString]]
                           stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (self.gsbType != nil) {
        urlString = [NSString stringWithFormat:[APIDefine benefitsGSB],
                     self.gsbType,
                     [NSLocalizedString(@"EN",nil) lowercaseString]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:urlRequest];
    
    // Customize Popup UI if presenting WinnersClub info
    if (self.gsbType) {
        self.popupContentViewTopSpace.constant = 110;
        self.popupContentViewBottomSpace.constant = 110;
    }
    
    // Setup web spinner
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.color = UIColor.redColor;
    CGRect spinnerFrame = spinner.frame;
    spinnerFrame.origin.x = self.popupContentView.frame.size.width / 2 - spinnerFrame.size.width / 2;
    spinnerFrame.origin.y = self.popupContentView.frame.size.height / 2 - spinnerFrame.size.height / 2;
    if (self.gsbType) {
        spinnerFrame.origin.y -= 50;
    }
    spinner.frame = spinnerFrame;
    [self.popupContentView addSubview:spinner];
    [spinner startAnimating];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)removeAnimate
{
    [UIView animateWithDuration:.4 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1, 1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

// MARK: - Actions
- (IBAction)touchCloseBtn:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchSeparateOKButton:(id)sender {
    [self removeAnimate];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (spinner != nil) {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
    }
}

@end
