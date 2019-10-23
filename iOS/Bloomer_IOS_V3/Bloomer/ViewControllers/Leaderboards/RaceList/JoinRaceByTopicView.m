//
//  JoinRaceByTopicView.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/20/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "JoinRaceByTopicView.h"
#import "RacesViewController.h"
#import "AppHelper.h"
#import "UploadAvatarPopUpView.h"
#import "RaceAlertView.h"

@interface JoinRaceByTopicView ()
{
    UserDefaultManager* userDefaultManager;
    RacesViewController*RaceView;
}


@end

@implementation JoinRaceByTopicView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userDefaultManager = [[UserDefaultManager alloc] init];

//    NSString* finaleDate = [NSLocalizedString(@"EndOn.Label",) stringByAppendingString:_sEndTime];
//    [_RaceName setHidden:true];
//    [_DateEnd setHidden:true];
    _RaceName.text = _raceNames;
    _DateEnd.text = _sEndTime;
//    [_DateEnd setHidden:true];
    _ContentWeb.scrollView.scrollEnabled = NO;
    _ContentWeb.scrollView.showsHorizontalScrollIndicator = NO;
    _ContentWeb.scrollView.showsVerticalScrollIndicator = NO;
    _ImageRace.contentMode = UIViewContentModeScaleAspectFit;
    [_ImageRace setImageWithURL:[NSURL URLWithString:_avatar]];
//    [_ImageRace setImage:[UIImage imageNamed:@"banner_leaderboad"]];
    [_BottomImageRace setImage:[UIImage imageNamed:@"banner_bottomline"]];
    [_jointButton setTitle:NSLocalizedString(@"RaceList.joinLeaderboards", ) forState:UIControlStateNormal];
    
    [self initNavigationBar];
    
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void) initNavigationBar
{
    [AppHelper setTitleViewForNavigationBar:self.navigationItem title:self.raceNames];
}

-(void) loadContent
{
    _ContentWeb.delegate = self;
    NSString *urlString = [_rules stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_ContentWeb loadRequest:urlRequest];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    return YES;
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
    _ContentWeb.scrollView.scrollEnabled = YES;
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
}

- (IBAction)TouchJoinNow:(id)sender {
//    [self doCheckJoinRace];
    UploadAvatarPopUpView *uploadAvatarPopUp = [UploadAvatarPopUpView createInView:[[UIApplication sharedApplication] keyWindow] parentView:self raceKey:self.key category:self.categoryType];
    uploadAvatarPopUp.OnRaceJoined = ^{
        if(self.OnRaceJoined != nil)
            self.OnRaceJoined();
    };
    [uploadAvatarPopUp showWithAnimated:true];
}

- (void)doCheckJoinRace {
    [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_CheckJoinRace *api = [[API_CheckJoinRace alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] key:self.key];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate *)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        
        if (response.status) {
            UploadAvatarPopUpView *uploadAvatarPopUp = [UploadAvatarPopUpView createInView:[UIApplication sharedApplication].keyWindow parentView:self raceKey:self.key category:self.categoryType];
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

@end
