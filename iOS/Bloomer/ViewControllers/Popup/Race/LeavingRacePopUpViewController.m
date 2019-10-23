//
//  LeavingRacePopUpViewController.m
//  Bloomer
//
//  Created by Tai Truong on 9/29/15.
//  Copyright © 2015 Glassegg. All rights reserved.
//

#import "LeavingRacePopUpViewController.h"
#import "UserDefaultManager.h"

@interface LeavingRacePopUpViewController ()

@end

@implementation LeavingRacePopUpViewController
{
    UserDefaultManager *userDefaultManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initView];
    
}
-(void) initView{
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];
//    _rulesTextView.text = _rules;
//    _lblRaceName.text = _raceName;
//    _lblRaceTime.text = _raceTime;
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_endTimes];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"d"];
//    NSString *day = [self daySuffixForDate:date];
//    NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
//    [formatters setDateFormat:@"MMM YYYY"];
//    _endTime.text = [NSString stringWithFormat:@"Ends %@%@ %@", [formatter stringFromDate:date], day, [formatters stringFromDate:date]];
    _popupView.layer.cornerRadius = 20;
    _btnCancel.layer.cornerRadius = _btnCancel.frame.size.height / 2;
    _btnLeave.layer.cornerRadius = _btnLeave.frame.size.height / 2;
    [self loadLeavingContent];
}


-(void) loadLeavingContent
{
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _leavingContentWebView.delegate = self;
    NSString *urlString = [_content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_leavingContentWebView loadRequest:urlRequest];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error-webview : %@", error);
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)touchCancelButton:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchLeaveButton:(id)sender {
    API_LeaveRace *api = [[API_LeaveRace alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:self.key];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            [self removeAnimate];
            
            if ([self.parentView isKindOfClass:[RaceListsViewController class]]) {
                RaceListsViewController *view = (RaceListsViewController *)self.parentView;
                
                [view reloadAllRaceLists];
            } else {
                RacesViewController *view = (RacesViewController *)_parentView;
                view.isJoin = 1;
                [view pullToRefresh];
                if(self.OnRaceLeft != nil) {
                    self.OnRaceLeft();
                }
                [self.navigationController popToRootViewControllerAnimated:TRUE];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:response.message
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } ErrorHandlure:^(NSError *error) {
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

@end
