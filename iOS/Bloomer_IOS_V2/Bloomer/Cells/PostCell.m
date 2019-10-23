//
//  PostCell.m
//  Bloomer
//
//  Created by Steven on 3/12/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "PostCell.h"
#import "UIColor+Extension.h"
#import <UIImageView+AFNetworking.h>
#import "NSDate+TimeAgo.h"
#import "UILabel+Extension.h"
#import "out_profile_fetch.h"
#import "UserDefaultManager.h"
#import "UserProfileViewController.h"
#import "CommentViewController.h"
#import "FlowerGiverViewController.h"
#import "PhotoListViewController.h"
#import "ThankYou.h"

@interface PostCell ()

@property (strong, nonatomic) out_profile_fetch *profileData;
@property (strong, nonatomic) UserDefaultManager *userDefaultManager;
@property (strong, nonatomic) out_content_post *postData;
@property (assign, nonatomic) BOOL touchedFlowerView;
@property (strong, nonatomic) FriendsUpdatePopupView *popup;
@property (strong, nonatomic) ThankYou* thankYouView;


@end

@implementation PostCell

+ (CGFloat)cellHeight
{
    return 494;
}

+ (NSString*)cellIdentifier
{
    return @"PostCell";
}

+ (NSString*)nibName
{
    return @"PostCell";
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.userDefaultManager = [[UserDefaultManager alloc] init];
    self.profileData = [self.userDefaultManager getUserProfileData];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderWidth = 2;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.avatar.clipsToBounds = true;
    
//    self.buttonRaceTags.layer.cornerRadius = self.buttonRaceTags.frame.size.height / 2;
//    self.buttonRaceTags.clipsToBounds = true;
    
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height / 2;
    self.userAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.userAvatar.layer.borderWidth = 3;
    self.userAvatar.clipsToBounds = true;
    
    self.otherAvatar.layer.cornerRadius = self.otherAvatar.frame.size.height / 2;
    self.otherAvatar.layer.borderColor = [UIColor colorFromHexString:@"#E4E4E4"].CGColor;
    self.otherAvatar.layer.borderWidth = 3;
    self.otherAvatar.clipsToBounds = true;
    
    self.flowerViewMainView.layer.cornerRadius = 20;
    self.flowerViewMainView.clipsToBounds = true;
    
    self.flowerView.clipsToBounds = true;
    self.flowerView.layer.shadowColor = [UIColor colorFromHexString:@"#A0A0A0"].CGColor;
    self.flowerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.flowerView.layer.shadowOpacity = 0.5;
    
    self.thankYouView = [[ThankYou alloc] initWithStyle:ThankYouStyleForCollectionViewCell atPoint:self.pictureView.frame.origin frame:CGRectMake(self.pictureView.frame.origin.x, self.pictureView.frame.origin.y, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.width)];
    [self addSubview:self.thankYouView];
    self.thankYouView.hidden = true;
    [self.buttonShare setTitle:NSLocalizedString(@"Share", ) forState:UIControlStateNormal];
    [self.buttonComment setTitle:NSLocalizedString(@"Comment", ) forState:UIControlStateNormal];

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.thankYouView.hidden = true;
    self.flowerView.hidden = true;
    self.touchedFlowerView = false;
}

- (void)bindData:(out_content_post*)data
{
    self.postData = data;
    
    self.labelName.text = data.name;
    self.labelUsername.text = data.username;
    self.labelCaption.text = data.caption;
    
    if ([data.caption isEqualToString:@""])
    {
        self.labelCaptionTopMargin.constant = 0;
        self.labelCaptionBottomMargin.constant = 0;
    }
    else
    {
        self.labelCaptionTopMargin.constant = 10;
        self.labelCaptionBottomMargin.constant = 10;
    }
    
    [self.avatar setImageWithURL:[NSURL URLWithString:data.avatar]];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:data.timestamp / 1000];
    [self.buttonMore setTitle:[date timeAgo] forState:UIControlStateNormal];
    
//    NSString* tagList=@"";
//    for (NSString* tag in data.tags)
//    {
//        tagList = [tagList stringByAppendingString:tag] ;
//    }
//    
//    [self.buttonRaceTags setTitle:tagList forState:UIControlStateNormal];
    
    if (data.is_share)
    {
        self.buttonShare.enabled = true;
    }
    else
    {
        self.buttonShare.enabled = false;
    }
    
    [self.buttonSponsor setUserInteractionEnabled:data.flower > 0];
    
    if (data.mygiveflower > 0)
    {
        [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#B22225"]];
        [self.labelFlower setFlowers:data.flower];
        
        [self.userAvatar setImageWithURL:[NSURL URLWithString:self.profileData.avatar]];
        self.labelUserName.text = self.profileData.name;
        [self.labelUserFlower setFlowers:data.mygiveflower imageString:@"Icon_Flower_Black"];
        self.labelOtherName.text = @"Other Users";
        [self.labelOtherFlower setFlowers:data.flower - data.mygiveflower imageString:@"Icon_Flower_Black"];
        
        self.iconGivedFlowerPhoto.hidden = false;
    }
    else
    {
        if (data.uid == self.profileData.uid)
        {
            if(data.flower == 0)
            {
                [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#6B6B6B"]];
                [self.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
            }
            else
            {
                [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#B22225"]];
                [self.labelFlower setFlowers:data.flower];
            }
        }
        else
        {
            [self.labelFlower setTextColor:[UIColor colorFromHexString:@"#6B6B6B"]];
            [self.labelFlower setFlowers:data.flower imageString:@"Icon_Flower_Black"];
        }
        
        self.iconGivedFlowerPhoto.hidden = true;
    }
}

- (void)hideFlowerView
{
    self.touchedFlowerView = false;
    [UIView animateWithDuration:0.25 animations:^{
        self.flowerView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.flowerView.hidden = true;
        }
    }];
}

- (void)showThankYouView:(BOOL)show
{
    if (show)
    {
        self.thankYouView.hidden = false;
        self.thankYouView.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.thankYouView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.thankYouView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished)
            {
                self.thankYouView.hidden = true;
            }
        }];
    }
}

// MARK: - Actions

- (IBAction)touchProfileButton:(id)sender
{
    if (self.profileData.uid != self.postData.uid)
    {
        UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.uid = self.postData.uid;
        
        [self.navigationController pushViewController:view animated:TRUE];
    }
    else
    {
        [AppDelegate setSelectedIndexTabbar:4];
    }
}

- (IBAction)touchMoreButton:(id)sender
{
    if (self.photo.image != nil)
    {
        PhotoListViewController *viewController = (PhotoListViewController*)self.parentViewController;
        
        NSIndexPath *indexPath = [viewController.tableView indexPathForCell:self];
        CGRect rectInTableView = [viewController.tableView rectForRowAtIndexPath:indexPath];
        CGRect rectInSuperView = [viewController.tableView convertRect:rectInTableView toView:viewController.view];
        
        self.popup = [FriendsUpdatePopupView createInView:[[[UIApplication sharedApplication] delegate] window]];
        self.popup.distance = rectInSuperView.origin.y + self.navigationController.navigationBar.frame.size.height + self.buttonMore.frame.size.height;
        self.popup.delegate = self;
        self.popup.post_id = self.postData.post_id;
        self.popup.isMe = (self.postData.uid == self.profileData.uid);
//        self.popup.following = self.postData.is_follow;
        self.popup.picture = self.photo.image;
        self.popup.caption = self.postData.caption;
        self.popup.parentView = self.parentViewController;
        self.popup.indexForEdit = self.indexForEdit;
        self.popup.isAvatar = _postData.is_avatar;
        [self.popup showWithAnimated:true];
    }
}

- (IBAction)touchSponsorButton:(id)sender
{
    if (self.postData.uid == self.profileData.uid)
    {
        FlowerGiverViewController *view = [[FlowerGiverViewController alloc] init];
        view.notificationKey = @"";
        view.post_id = self.postData.post_id;
        view.userID = self.postData.uid;
        view.hidesBottomBarWhenPushed = true;

        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        if (self.postData.mygiveflower > 0 && !self.touchedFlowerView)
        {
            self.flowerView.alpha = 0;
            self.flowerView.hidden = false;
            self.touchedFlowerView = true;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.flowerView.alpha = 1;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self hideFlowerView];
                });
            }];
        }
    }
}

- (IBAction)touchCommentButton:(id)sender
{
    CommentViewController *view = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    view.parentView = self.parentViewController;
    view.hidesBottomBarWhenPushed = TRUE;
    view.post_id = self.postData.post_id;
    view.displayName = self.postData.name;
    view.postCaption = self.postData.caption;
    view.post_UserID = self.postData.uid;
    
    [self.navigationController pushViewController:view animated:TRUE];
}

- (IBAction)touchShareButton:(id)sender
{
    if (self.photo.image != nil)
    {
        if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Install and log in to Facebook to enable sharing pictures.", ) delegate:nil cancelButtonTitle:NSLocalizedString(@"Alert.TryAgain", ) otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        
        photo.image = self.photo.image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.delegate = self;
        dialog.fromViewController = self.parentViewController;
        dialog.shareContent = content;
        dialog.mode = FBSDKShareDialogModeAutomatic;
        
        [dialog show];
    }
}

// MARK: - FriendsUpdatePopupViewDelegate
- (void)touchDeletePostWith:(NSString *)postID{

    if ([self.delegate respondsToSelector:@selector(deletePostCellWithPostID:)]) { //Callback to PhotoListVC
        [self.delegate deletePostCellWithPostID:postID];
    }
    
}

// MARK: - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
    API_ShareFacebook* api = [[API_ShareFacebook alloc] initWithAccessToken:[self.userDefaultManager getAccessToken] device_token:[self.userDefaultManager getDeviceToken] isPopup:NO];
    [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
        if(response.status) {
            Json_ShareFacebook *data = (Json_ShareFacebook*)jsonObject;
            self.profileData.your_num_flower += data.flower;
            [self.userDefaultManager saveUserProfileData:self.profileData];
        }
    } ErrorHandlure:^(NSError *error) {
        
    }];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
    
}

@end
