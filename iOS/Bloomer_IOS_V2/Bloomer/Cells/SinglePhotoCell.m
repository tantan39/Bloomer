//
//  SinglePhotoCell.m
//  Bloomer
//
//  Created by Steven on 12/9/16.
//  Copyright © 2016 Glassegg. All rights reserved.
//

#import "SinglePhotoCell.h"
#import "UIColor+Extension.h"
#import "AppHelper.h"
#import "AnonymousUserProfileViewController.h"

@implementation SinglePhotoCell
{
    NSLayoutConstraint *aspectConstraint;
    gallery* gallerypost;
    BOOL showingThankyou;
}

+ (CGFloat)cellHeight
{
    return 372;
}

+ (NSString*)cellIdentifier
{
    return @"SinglePhotoCell";
}

+ (NSString*)nibName
{
    return @"SinglePhotoCell";
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.thankYouView.hidden = true;
    self.profileThankYouView.hidden = true;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.thankYouLabel.text = [AppHelper getLocalizedString:@"userprofile.thankYou.popup"];
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height / 2;
    self.avatar.layer.borderWidth = 1;
    self.avatar.layer.borderColor = [UIColor colorFromHexString:@"#FFFFFF"].CGColor;
    self.avatar.clipsToBounds = true;
    
    self.profileThankYouLabel.text = [AppHelper getLocalizedString:@"Chat.popup.thankyou"];
    
    UITapGestureRecognizer *pictureViewTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage)];
    [self.pictureView addGestureRecognizer:pictureViewTapRecognizer];
    
    showingThankyou = false;
}

- (void)setPhotoWithImage:(UIImage*)image
{
    CGFloat aspect = image.size.width / image.size.height;
    
    if (aspectConstraint != nil)
    {
        [self.pictureView removeConstraint:aspectConstraint];
    }
    
    aspectConstraint = [NSLayoutConstraint constraintWithItem:self.pictureView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.pictureView attribute:NSLayoutAttributeHeight multiplier:aspect constant:0];
    aspectConstraint.priority = 750;
    [self.pictureView addConstraint:aspectConstraint];
    self.photo.image = image;
    
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// MARK: - Selectors

- (void)touchImage
{
    UserDefaultManager *userDefaultManager = [[UserDefaultManager alloc] init];
    if ([userDefaultManager isAnonymous])
    {
        [AppHelper showAnonymousLoginPopUpView];
    }
    else
    {
        FullPictureViewController *view = [[FullPictureViewController alloc] initWithNibName:@"FullPictureViewController" bundle:nil];
        
        gallerypost = [[gallery alloc] init];
        gallerypost.post_id = _post_id;
        gallerypost.photo_url = _post_url;
        
        view.post_id = _post_id;
        view.isScrollingEnabled = FALSE;
        view.galleryData = [[NSMutableArray alloc]initWithObjects:gallerypost, nil];
        view.currentIndex = 0;
        
        [_navigationController pushViewController:view animated:TRUE];
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
