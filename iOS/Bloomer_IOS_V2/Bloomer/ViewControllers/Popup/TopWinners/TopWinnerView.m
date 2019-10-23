//
//  TopWinnerView.m
//  Bloomer
//
//  Created by Steven on 1/3/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "TopWinnerView.h"
#import <UIImageView+AFNetworking.h>

@interface TopWinnerView()
{
    NSString * urlWeb;
    NSString * popupID;
    UserDefaultManager * userDefaultManager;
    ShareRewardView *popup;
}
@end

@implementation TopWinnerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.shareButton.layer.cornerRadius = self.shareButton.frame.size.height / 2;
    self.shareButton.clipsToBounds = true;
}

- (void)bindData:(TopWinner*)data flowers:(NSInteger)flowers
{
    urlWeb = data.url;
    popupID = data.popUpID;
    
    [self.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
    self.shareFlowerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"numberFlowerReward.label", nil), (long)flowers];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSString* msg = [[NSString alloc] initWithFormat:@"<font style='font-size:14px;font-family:SFUIText-Medium'>%@</font>", data.message];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUnicodeStringEncoding]
                                                                                                 options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                                                      documentAttributes:nil
                                                                                                   error:nil];
    [mutableAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, mutableAttributedString.length)];
    
    self.contentLabel.attributedText = mutableAttributedString;
}

- (IBAction)TouchShare:(id)sender
{
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
    dialog.mode = FBSDKShareDialogModeAutomatic ;
    dialog.fromViewController = self.navigationController;
    [dialog show];
    
    [UIApplication.sharedApplication.keyWindow sendSubviewToBack:self.parentView];
}

// MARK: - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.parentView];
    NSLog(@"error : %@", error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    userDefaultManager = [[UserDefaultManager alloc] init];
    API_RewardShare *API = [[API_RewardShare alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceToken:[userDefaultManager getDeviceToken] shareID:popupID isPopup:TRUE];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        rewardShare * data = (rewardShare *) jsonObject;
        
        if (response.status && data.numflower > 0)
        {
            popup = [[ShareRewardView alloc] initWithNibName:@"ShareRewardView" bundle:nil];
            popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
            [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE andNumberFlower:data.numflower];
            self.didCompleteShareFacebook();
        }
        else
        {

        }
        
        [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.parentView];
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.parentView];
    }];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.parentView];
}

// MARK: - API_ShareFacebookDelegate

//- (void)shareFacebookSuccessful:(Json_ShareFacebook *)data
//{
//    out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
//    profileData.your_num_flower += data.flower;
//    [userDefaultManager saveUserProfileData:profileData];
//}

@end
