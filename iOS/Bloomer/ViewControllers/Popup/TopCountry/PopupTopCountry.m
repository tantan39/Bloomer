//
//  PopupForWinner.m
//  Bloomer
//
//  Created by Nguyen Thanh  Tu on 12/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "PopupTopCountry.h"
#import "Support.h"

@interface PopupTopCountry ()
{
    UserDefaultManager *userDefaultManager;
    NSString * textName;
    NSString * nameWinnerText;
    NSString * myAvatar;
    NSString * bannerName;
    NSString * myMessage;
    NSString * urlWeb;
    NSString * myKey;
}
@end

@implementation PopupTopCountry

-(void)viewDidLoad {
    [super viewDidLoad];
    _PopUp.layer.cornerRadius = 20;
    _CongratsLabel.text = NSLocalizedString(@"PopUpWinner.congrats", );
    [_Sharebutton setTitle:NSLocalizedString(@"PopUpWinnerShare.Button", ) forState:UIControlStateNormal];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
}

-(void) initData
{
    _WinnerImage.image = nil;
    _NameWinner.text = @"";
}

-(void) loadPopupWinner:(NSString*) key withInformation:(NSString*) info withRaceName:(NSString*) name withRank:(NSInteger) rank withImage:(NSString *) avatar andURL:(NSString *) link
{
    [self initData];
    urlWeb = link;
    myAvatar = avatar;
    nameWinnerText= [@"You won " stringByAppendingString:[Support suffixForRank: rank]];
    textName = [name stringByAppendingString:@" Leaderboard "];
    myKey = key;
    if([key  isEqual: @"y"])
    {
        bannerName = @"PopUpWinner_Yearly";
        textName = [textName stringByAppendingString:@"year!"];
    }
    else if([key  isEqual: @"m"])
    {
        // month
        bannerName = @"PopUpWinner_Month";
        
        textName = [textName stringByAppendingString:@"month!"];
    }
    else if([key  isEqual: @"w"])
    {
        bannerName = @"PopUpWinner_weekly";
        textName = [textName stringByAppendingString:@"this week!"];
    }
    else if([key  isEqual: @"d"])
    {
        bannerName = @"PopUpWinner_Dayly";
        textName = [textName stringByAppendingString:@"today!"];
    }
    myMessage = info;
}

- (void)showInView:(UIView*)view animated:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [view addSubview:self.view];
        if(animated) {
            [self showAnimate];
        }
    });
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
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
        [_WinnerImage setImageWithURL:[NSURL URLWithString:myAvatar]];
        
        NSError *err = nil;
        
        _NameWinner.numberOfLines = 0;
        _NameWinner.attributedText =
        [[NSAttributedString alloc]
         initWithData: [myMessage dataUsingEncoding:NSUnicodeStringEncoding]
         options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding) }
         documentAttributes: nil
         error: &err];
        if(err)
            NSLog(@"Unable to parse label text: %@", err);
        [_NameWinner setFont:[UIFont fontWithName:@"SFProText-Medium" size:14.0]];
        _NameWinner.textAlignment = NSTextAlignmentCenter;
        
    }];
    
}

- (IBAction)touchShare:(id)sender {
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Install and log in to Facebook to enable sharing pictures.", ) delegate:nil cancelButtonTitle:NSLocalizedString(@"Alert.TryAgain", ) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:urlWeb];
    content.hashtag = [FBSDKHashtag hashtagWithString:@"#BloomerApp"];
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.delegate = self;
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeAutomatic;
    dialog.fromViewController = self;
    [dialog show];
}

- (IBAction)CancelButton:(id)sender {
    [self removeAnimate];
    self.popup_onClose();
}

// MARK: - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    API_ShareFacebook* api = [[API_ShareFacebook alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] isPopup:YES];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [self removeAnimate];
        self.popup_onClose();
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{

}

// MARK: - API_ShareFacebookDelegate

//- (void)shareFacebookSuccessful:(Json_ShareFacebook *)data
//{
//    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
//    profileData.your_num_flower += data.flower;
//    [userDefaultManager saveUserProfileData:profileData];
//}

@end
