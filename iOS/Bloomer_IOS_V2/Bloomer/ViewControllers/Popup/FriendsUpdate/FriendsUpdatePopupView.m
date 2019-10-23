//
//  FriendsUpdatePopupView.m
//  Bloomer
//
//  Created by Steven on 1/1/17.
//  Copyright © 2017 Glassegg. All rights reserved.
//

#import "FriendsUpdatePopupView.h"
#import "PhotoListViewController.h"
#import "UploadingPicturesTableViewController.h"
#import "AppHelper.h"
#import "UIView+Extension.h"

@implementation FriendsUpdatePopupView
{
    SelectionReasonReportViewController *popup;
    UserDefaultManager *userDefaultManager;
    UIAlertView *changeCaption;
    UIAlertView *deletePost;
}

+ (id)createInView:(UIView*)view
{
    FriendsUpdatePopupView *popupView = [[NSBundle mainBundle] loadNibNamed:@"FriendsUpdatePopupView" owner:view options:nil][0];
    popupView.translatesAutoresizingMaskIntoConstraints = false;
    popupView.ownerView = view;
    
    return popupView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    userDefaultManager = [[UserDefaultManager alloc] init];
    
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.2];
    
    self.labelView.layer.cornerRadius = 10;
//    self.labelReport.layer.cornerRadius = 10;
    self.labelFollowView.layer.cornerRadius = 10;
    self.unFollowBGView.layer.cornerRadius = 10;
    
    self.labelView.clipsToBounds = true;
//    self.labelReport.clipsToBounds = true;
    self.labelFollowView.clipsToBounds = true;
    self.unFollowBGView.clipsToBounds = true;
    
    self.unfollowButton.titleLabel.numberOfLines = 0;
    self.unfollowButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.unfollowButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.unfollowButton setTitle:[AppHelper getLocalizedString:@"Popup.buttonUnfollow"] forState: UIControlStateNormal];
    //    self.unfollowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self setupLanguage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closePopup)];
    
    [self addGestureRecognizer:tap];
}

- (void)setupLanguage
{
    for (NSInteger i = 0; i < self.buttonEditContentList.count; i++)
    {
        UIButton *button = [self.buttonEditContentList objectAtIndex:i];
        [button setTitle:[AppHelper getLocalizedString:@"Popup.buttonEditContent"] forState:UIControlStateNormal];
    }
    
    for (NSInteger i = 0; i < self.buttonSavePictureList.count; i++)
    {
        UIButton *button = [self.buttonSavePictureList objectAtIndex:i];
        [button setTitle:[AppHelper getLocalizedString:@"Popup.buttonSavePicture"] forState:UIControlStateNormal];
    }
    
    for (NSInteger i = 0; i < self.buttonReportPictureList.count; i++)
    {
        UIButton *button = [self.buttonReportPictureList objectAtIndex:i];
        [button setTitle:[AppHelper getLocalizedString:@"Popup.buttonReportPicture"] forState:UIControlStateNormal];
    }
    
    for (NSInteger i = 0; i < self.buttonDeletePictureList.count; i++)
    {
        UIButton *button = [self.buttonDeletePictureList objectAtIndex:i];
        [button setTitle:[AppHelper getLocalizedString:@"Popup.buttonDeletePicture"] forState:UIControlStateNormal];
    }
}

- (void)movePopupToTheRightPosition
{
    if (self.isMe)
    {
        self.popupViewTopMargin.constant = self.distance + 15;
        
        [self.userPopupView setHidden:TRUE];
        [self.followUserPopupView setHidden:TRUE];
//        [self.unFollowView setHidden:TRUE];
    }
    else
    {
        if (self.isNewFeeds)
        {
//            self.stopSeeingPopupViewTopMargin.constant = self.distance + 15;
            
            [self.popupView setHidden:TRUE];
            [self.userPopupView setHidden:TRUE];
            [self.followUserPopupView setHidden:TRUE];
        }
        else
        {
            if (!self.following)
            {
//                self.photoPopupViewTopMargin.constant = self.distance + 15;
                self.onePhotoPopupViewTopMargin.constant = self.distance + 15;
                [self.popupView setHidden:TRUE];
//                [self.unFollowView setHidden:TRUE];
//                [self.followUserPopupView setHidden:TRUE];
            }
            else
            {

                self.onePhotoPopupViewTopMargin.constant = self.distance + 15;
                
                [self.popupView setHidden:TRUE];
//                [self.unFollowView setHidden:TRUE];
                [self.userPopupView setHidden:TRUE];
//                [self.followUserPopupView setHidden:TRUE];
                
            }
        }
    }
}

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
        [self movePopupToTheRightPosition];
        [self.ownerView layoutIfNeeded];
        
        if (animated)
        {
            [self showAnimate];
        }
    });
}

- (void)closePopup
{
    [self removeAnimate];
}

- (IBAction)touchReport:(id)sender {
    [self removeAnimate];
    
    popup = [[SelectionReasonReportViewController alloc] initWithNibName:@"SelectionReasonReportViewController" bundle:nil];
    popup.post_id = self.post_id;
    popup.isUser = FALSE;
    popup.view.frame = [UIScreen mainScreen].bounds; // Get device's bounds
    [popup showInView:[[[UIApplication sharedApplication] delegate] window] animated:TRUE];
}

- (IBAction)touchEdit:(id)sender {
    UploadingPicturesTableViewController *view = [[UploadingPicturesTableViewController alloc] init];
    view.parentView = self.parentView;
    view.captions = [[NSMutableArray alloc] initWithObjects:self.caption, nil];
    view.postID = self.post_id;
    view.isCaptionEditting = true;
    view.indexForEdit = self.indexForEdit;
    view.uploadPhotos = [[NSMutableArray alloc] initWithObjects:self.picture, nil];
    
    if([_parentView isKindOfClass:[PhotoListViewController class]])
    {
        PhotoListViewController* tempView = (PhotoListViewController*)_parentView;
        view.name = tempView.raceName;
    } else if ([_parentView isKindOfClass:[FullPictureViewController class]])
    {
        FullPictureViewController* tempView = (FullPictureViewController*)_parentView;
        view.name = tempView.raceName;
    }
    
    [self removeAnimate];
    [self.parentView.navigationController pushViewController:view animated:TRUE];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self removeAnimate];
    if (buttonIndex == 1)
    {
        if (alertView == changeCaption) {
            
            caption_post *param = [[caption_post alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:self.post_id caption:[alertView textFieldAtIndex:0].text];
            if (param) {
                API_CaptionEdit *api = [[API_CaptionEdit alloc] initWithParams:param];
                [api request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    if (response.status)
                    {
                        FullPictureViewController *view = (FullPictureViewController *)self.parentView;
                        [view loadContentPost];
                    }
                    else
                    {
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                } ErrorHandlure:^(NSError *error) {
                    
                }];
            }
            

        } else if (alertView == deletePost){
            if (self.post_id) {
                [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner startAnimating];
                API_Post_Delete *deletePostAPI = [[API_Post_Delete alloc] initWithAccessToken:[userDefaultManager getAccessToken] device_token:[userDefaultManager getDeviceToken] post_id:self.post_id];
                [deletePostAPI request:^(BaseJSON *jsonObject, RestfulResponse *response) {
                    [self removeAnimate];
                    
                    if (response.status)
                    {
                        if ([self.delegate respondsToSelector:@selector(touchDeletePostWith:)]) {
                            [self.delegate touchDeletePostWith:self.post_id];
                        }
                    } else{
                        [AppHelper showMessageBox:nil message:response.message];
                    }
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                    
                } ErrorHandlure:^(NSError *error) {
                    [((AppDelegate*)[UIApplication sharedApplication].delegate).spinner stopAnimating];
                }];
            }

        }
    }
}

- (IBAction)touchDelete:(id)sender {

    deletePost = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"Are you sure you want to delete this picture?",nil)
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"No",nil)
                                  otherButtonTitles:NSLocalizedString(@"Yes",nil), nil];
    [deletePost dismissWithClickedButtonIndex:0 animated:TRUE];
    [deletePost show];
}

- (IBAction)touchCancelButton:(id)sender {
    [self removeAnimate];
}


- (IBAction)touchStopSeeing:(id)sender {
    [self removeAnimate];
    if(self.isNewFeeds){
        //        SinglePhotoCell *view = (SinglePhotoCell*)self.parentView;
        //        [view touchUnFollow];
    } else {
        if([self.parentView isKindOfClass:[FullPictureViewController class]]) {
            FullPictureViewController *view = (FullPictureViewController *)self.parentView;
            [view touchUnFollow];
        } else if([self.parentView isKindOfClass:[PhotoListViewController class]]) {
            PhotoListViewController *view = (PhotoListViewController*)self.parentView;
            [view touchUnFollow];
        }
    }
    
}

- (IBAction)touchSavePictureToDevice:(id)sender
{
    UIImageWriteToSavedPhotosAlbum(self.picture, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// MAKR: - Selectors
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    if (error != nil)
    {
        [AppHelper showMessageBox:[AppHelper getLocalizedString:@"common.error"] message:[AppHelper getLocalizedString:@"Popup.savePictureFail"]];
        NSLog(@"Error : %@", error);
    }
    else
    {
        [AppHelper showMessageBox:[AppHelper getLocalizedString:@"Popup.savePictureSuccessful"] message:nil];
        [self removeAnimate];
    }
}

@end
