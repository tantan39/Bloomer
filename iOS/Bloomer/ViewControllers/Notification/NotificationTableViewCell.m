//
//  NotificationTableViewCell.m
//  Bloomer
//
//  Created by Truong Thuan Tai on 7/29/15.
//  Copyright (c) 2015 Glassegg. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "FlowerGiverViewController.h"

@interface NotificationTableViewCell()
{
    NSString * popupID;
    UserDefaultManager * userDefaultManager;
    ShareRewardView *popup;
    BOOL can_share;
}
@end

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _buttonShare.layer.cornerRadius = _buttonShare.frame.size.height / 2;
    userDefaultManager =[[UserDefaultManager alloc] init];
    [self prepareForReuse];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    _content.text = @"";
    _contentWidth.constant = 1.0 * [UIScreen mainScreen].bounds.size.width / 320 * 250;
    _time.text = @"";
    _avatar.image = nil;
    _photo.contentMode = UIViewContentModeScaleAspectFit;
    _photo.image = nil;
    _ChatIcon.image = nil;
    [_photo setHidden:YES];
    [_ChatIcon setHidden:YES];
    [_imageButton setHidden:YES];
    [_ContentButton setHidden:YES];
    [_AvatarButton setHidden:YES];
    [self.shareView setHidden:YES];
    
    can_share = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)touchAvatar:(id)sender {
    UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
    
    switch (_noti.type) {
        case NOTIFICATION_TYPE_FLOWER_AVATAR:
            view.uid = _noti.avatarContent.giver_id;
            break;
            
        default:
            view.uid = _noti.photoContent.uidAvatar;
            break;
    }
    
    view.hidesBottomBarWhenPushed = NO;
    [self.myNavigationController pushViewController:view animated:YES];
}

- (IBAction)touchContent:(id)sender {
    //    ListOfFlowerGiver *view = [[ListOfFlowerGiver alloc] initWithNibName:@"ListOfFlowerGiver" bundle:nil];
    //    [view loadAllUser:_noti.photoContent.post_id];
    //    view.hidesBottomBarWhenPushed = NO;
    //    [self.myNavigationController pushViewController:view animated:YES];
    
    FlowerGiverViewController *view = [[FlowerGiverViewController alloc] initWithNibName:@"FlowerGiverViewController" bundle:nil];
    view.notificationKey = @"";
    view.post_id = _noti.photoContent.post_id;
    view.hidesBottomBarWhenPushed = true;
    [self.myNavigationController pushViewController:view animated:YES];
}

- (IBAction)touchImage:(id)sender {
    FullPictureViewController *view;
    view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
    
    gallery* gallerypost = [[gallery alloc]init];
    gallerypost.post_id = _noti.photoContent.post_id;
//    gallerypost.photo_url =  [_noti.photoContent.photo_url stringByReplacingOccurrencesOfString:@"-s." withString:@"-l."];
    
    view.post_id = _noti.photoContent.post_id;
    view.isScrollingEnabled = FALSE;
    view.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
    view.currentIndex = 0;
    view.hidesBottomBarWhenPushed = TRUE;
    [self.myNavigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchShareButton:(id)sender
{
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Install and log in to Facebook to enable sharing pictures.", ) delegate:nil cancelButtonTitle:NSLocalizedString(@"Alert.TryAgain", ) otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if(!can_share)
        return;
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    if(_noti.topCountry) {
        content.contentURL = [NSURL URLWithString:_noti.topCountry.url];
    } else if (_noti.welcomeGSB) {
        content.contentURL = [NSURL URLWithString:_noti.welcomeGSB.url];
    }
    content.hashtag = [FBSDKHashtag hashtagWithString:@"#BloomerApp"];
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = _myNavigationController;
    dialog.shareContent = content;
    dialog.mode = FBSDKShareDialogModeShareSheet;
    dialog.delegate = self;
    [dialog show];
}

-(void)setShareState:(BOOL)enabled {
    can_share = enabled;
    if(enabled) {
        _buttonShare.backgroundColor = [UIColor colorWithRed:0.312 green:0.632 blue:0.977 alpha:1];
    } else {
        _buttonShare.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    }
}

// MARK: - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
    
    API_RewardShare *API = [[API_RewardShare alloc] initWithAccessToken:[userDefaultManager getAccessToken] deviceToken:[userDefaultManager getDeviceToken] shareID:_noti.notification_id isPopup:FALSE];
    [API request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
        rewardShare * data = (rewardShare *) jsonObject;
        if (response.status) {
             [self setShareState:NO];
            if ([self.delegate respondsToSelector:@selector(shareNotificationSuccess:type:)]) {
                [self.delegate shareNotificationSuccess:_noti.notification_id type:_noti.type];
            }
            if(data.numflower > 0) {
               
                popup = [[ShareRewardView alloc] initWithNibName:@"ShareRewardView" bundle:nil];
                
                popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
                [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE andNumberFlower:data.numflower];
            }
        } else {
            [AppHelper showMessageBox:[AppHelper getLocalizedString:@"common.error"] message:response.message];
        }
    } ErrorHandlure:^(NSError *error) {
        [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
    }];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}
@end
