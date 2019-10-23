//
//  FourPhotosCell.m
//  Bloomer
//
//  Created by Steven on 12/12/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "FourPhotosCell.h"
#import "PhotoListViewController.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "AnonymousUserProfileViewController.h"

@implementation FourPhotosCell
{
    NSLayoutConstraint *aspectConstraint;
    NSMutableArray *postIDs;
    BOOL showingThankyou;
}

+ (CGFloat)cellHeight
{
    return 372;
}

+ (NSString*)cellIdentifier
{
    return @"FourPhotosCell";
}

+ (NSString*)nibName
{
    return @"FourPhotosCell";
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIView *view in self.thankYouViews)
    {
        view.hidden = true;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    for (UILabel *label in self.thankYouLabels)
    {
        label.text = [AppHelper getLocalizedString:@"userprofile.thankYou.popup"];
    }
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    self.avatar.clipsToBounds = true;
    
    self.profileThankYouLabel.text = [AppHelper getLocalizedString:@"Chat.popup.thankyou"];
    
    for (UIView* pictureView in self.pictureViews)
    {
        UITapGestureRecognizer *pictureViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)];
        [pictureView addGestureRecognizer:pictureViewTapRecognizer];
    }
    
    showingThankyou = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setLastPhotoWithImage:(UIImage*)image
{
    UIImageView *lastImageView = (UIImageView*)self.photos.lastObject;
    UIView *lastPictureView = (UIView*)self.pictureViews.lastObject;
    CGFloat aspect = image.size.width / image.size.height;
    
    if (aspectConstraint != nil)
    {
        [lastPictureView removeConstraint:aspectConstraint];
    }
    
    aspectConstraint = [NSLayoutConstraint constraintWithItem:lastPictureView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastPictureView attribute:NSLayoutAttributeHeight multiplier:aspect constant:0];
    aspectConstraint.priority = 750;
    [lastPictureView addConstraint:aspectConstraint];
    lastImageView.image = image;
    
    [self layoutIfNeeded];
}

// MARK: - Selectors
- (void)touchImage:(UITapGestureRecognizer *)sender
{
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    else
    {
        UIView *pictureView = (UIView*)sender.view;
        PhotoListViewController *viewController = [[PhotoListViewController alloc] initWithNibName:@"PhotoListViewController" bundle:nil];
        
        postIDs = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < self.feedPics.count; i++) {
            PostContent *feedPic = (PostContent *)self.feedPics[i];
            if (feedPic.photo_id.length != 0) {
                [postIDs addObject:feedPic.photo_id];
            } else if (feedPic.post_id.length != 0) {
                [postIDs addObject:feedPic.post_id];
            }
        }
        viewController.feed_id = self.feedID;
        viewController.postIDs = postIDs;
        viewController.raceName = _labelName.text;
        viewController.currentIndexPath = [NSIndexPath indexPathForRow:pictureView.tag inSection:0];
        
        UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
        out_profile_fetch *profileData = [userDefaultManager getUserProfileData];
        
        if (profileData.uid == self.uid)
        {
            viewController.hidesBottomBarWhenPushed = true;
        }
        else
        {
            viewController.hidesBottomBarWhenPushed = false;
        }
        viewController.uid = self.uid;
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}

// MARK: - Actions
- (IBAction)touchAvatarButton:(id)sender
{
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    if ([userDefaultManager isAnonymous])
    {
        AnonymousUserProfileViewController *view = [[AnonymousUserProfileViewController alloc] initWithNibName:@"AnonymousUserProfileViewController" bundle:nil];
        view.uid = _uid;
        
        [self.navigationController pushViewController:view animated:YES];
    }
    else
    {
        UserProfileViewController *view = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        view.uid = _uid;
        
        [self.navigationController pushViewController:view animated:YES];
    }
}

@end
