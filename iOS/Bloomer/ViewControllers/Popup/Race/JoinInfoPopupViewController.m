//
//  JoinInfoPopupViewController.m
//  Bloomer
//
//  Created by Tran Quang Vinh on 5/18/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "JoinInfoPopupViewController.h"

@interface JoinInfoPopupViewController () {
     UserDefaultManager *userDefaultManager;
    ImagePickerRaceViewController *popupJoin;
    ConfirmationPopupViewController *popup;
    
//    NSString *sEndTime;
}
@property (weak, nonatomic) IBOutlet UIWebView *leaderboardContent;
@property (weak, nonatomic) IBOutlet UILabel *lbltitle;

@property (nonatomic, strong) void(^completionHandler)(NSString *, NSInteger);

@end

@implementation JoinInfoPopupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        userDefaultManager = [[UserDefaultManager alloc] init];
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
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.70];
//    _rulesTextView.text = _rules;
//    _raceName.text = _raceNames;
    
    /*NSDate *date = [NSDate dateWithTimeIntervalSince1970:_endTimes];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    NSString *day = [self daySuffixForDate:date];
    NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
    [formatters setDateFormat:@"MMM YYYY"];
    _endTime.text = [NSString stringWithFormat:@"Ends %@%@ %@", [formatter stringFromDate:date], day, [formatters stringFromDate:date]]; */
    
//    _endTime.text = _sEndTime;
    _popupView.layer.cornerRadius = 20;
    _cancelButton.layer.cornerRadius = _cancelButton.frame.size.height / 2;
    _OKButton.layer.cornerRadius = _OKButton.frame.size.height / 2;
    
//    if(_categoryType == RACECATEGORY_LOCATION){
//        [_lbltitle setText:NSLocalizedString(@"You are switching to",nil)];
//    }else {
//        [_lbltitle setText:NSLocalizedString(@"You are joining",nil)];
//    }
    [_OKButton setTitle:NSLocalizedString(@"PopupSwitch.Yes", ) forState:UIControlStateNormal];
    [_cancelButton setTitle:NSLocalizedString(@"PopupSwitch.No", ) forState:UIControlStateNormal];
    [self loadLeaderboardContent];
}

-(void) loadLeaderboardContent
{
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _leaderboardContent.delegate = self;
    NSString *urlString = [_rules stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_leaderboardContent loadRequest:urlRequest];
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
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (([touch view] == _popupView) || ([touch view] == _rulesTextView)) {
        return NO;
    } else {
        //[self removeAnimate];
    }
    
    return YES;
}

- (IBAction)touchCancel:(id)sender {
    [self removeAnimate];
}

- (IBAction)touchOK:(id)sender {
    [self doCheckJoinRace];
    
}

- (void)doCheckJoinRace {
    API_CheckJoinRace *api = [[API_CheckJoinRace alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:self.key];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if (response.status) {
            [self removeAnimate];
            if (self.categoryType > RACECATEGORY_LOCATION) {
                popupJoin = [[ImagePickerRaceViewController alloc] initWithNibName:@"ImagePickerRaceViewController" bundle:nil];
                popupJoin.parentView = self.parentView;
                popupJoin.key = self.key;
                popupJoin.categoryType = self.categoryType;
                popupJoin.raceName = self.raceNames;
                [popupJoin showInView:[[[UIApplication sharedApplication] delegate] window] animated:true];
                
            } else if (([self.parentView isKindOfClass:[RacesViewController class]])) {
                [self SwitchPopupOK:self.locationID andKey:self.key];
                
            } else {
                self.completionHandler(@"ok", self.locationID);
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

- (void)showInView:(UICollectionViewCell *)view withCompletionHandler:(void (^)(NSString *, NSInteger))handler {
    _completionHandler = handler;
}

-(void)SwitchPopupOK:(NSInteger) locID andKey:(NSString *)myKey
{
    UserDefaultManager *userManager = [(AppDelegate *)[UIApplication sharedApplication].delegate getUserManager];
    location *param = [[location alloc] initWithAccess_Token:[userManager getAccessToken] device_token:[userManager getDeviceToken] locationID:locID];
    if (param) {
        API_Profile_Location *api = [[API_Profile_Location alloc] initWithParams:param];
        [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
            if (response.status) {
                RacesViewController *view = (RacesViewController *)_parentView;
                view.isJoin = RACE_JOINED;
                [view loadRaceInfo];
                [view pullToRefresh];
                if(self.OnRaceJoined != nil) {
                    self.OnRaceJoined();
                }
                [self.navigationController popToRootViewControllerAnimated:TRUE];
            }
        } ErrorHandlure:^(NSError *error) {
            [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        }];
        
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    }
}

@end
