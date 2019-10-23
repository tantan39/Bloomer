//
//  MyProfileHeaderViewCell.m
//  Bloomer
//
//  Created by Tan Tan on 11/19/18.
//  Copyright © 2018 Glassegg. All rights reserved.
//

#import "MyProfileHeaderViewCell.h"
#import "UIView+Extension.h"

static CGFloat cellHeight = 630;
static CGFloat updateInfoViewHeight = 120;

@implementation MyProfileHeaderViewCell

+ (CGFloat)cellHeight{
    return 500;
}

+ (NSString *)cellIdentifier{
    return @"MyProfileHeaderViewCell";
}

+ (NSString *)nibName{
    return @"MyProfileHeaderViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.btnAchievement setIconEdgeInset];
    [self.btnAchievement setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 3.0)];
    [self.btnChat setIconEdgeInset];
    [self.btnChat setShadowRadius:4.0f shadowOffset:CGSizeMake(0, 3.0f)];
    
    [self selectedDisplayMode:PHOTOS];
    
}

- (CGFloat)getCellHeight{
    if (self.isUpdateInfo) {
        return cellHeight + updateInfoViewHeight;
    }
    return cellHeight;
}

- (void) hideGSBIcon{
    [self.imgvGSB setHidden:YES];
    self.imgvGSB_WidthConstraint.constant = 0;
    self.btnEditProfile_PaddingLeftConstraint.constant -= self.btnEditProfile_PaddingLeftConstraint.constant;
}

- (void) selectedDisplayMode:(PhotosDisplayMode) mode{
    
    switch (mode) {
        case PHOTOS:{
            [self updateStackViewDisplayModeWithIndex:0];
            
            CGFloat xOffset = self.stackViewDisplayMode.center.x / 3 - self.underlineView.bounds.size.width / 2;
            
            self.underlineView_PaddingLeftConstraint.constant = xOffset;
        }
            break;
        case POSTS:{
            [self updateStackViewDisplayModeWithIndex:1];
            
            CGFloat xOffset = self.stackViewDisplayMode.center.x - self.underlineView.bounds.size.width / 2;
            
            self.underlineView_PaddingLeftConstraint.constant = xOffset;

        }
            break;
        case ALBUMS:{
            [self updateStackViewDisplayModeWithIndex:2];
            
            CGFloat xOffset = (self.stackViewDisplayMode.center.x / 3  * 5) - ( self.underlineView.bounds.size.width / 2);
            
            self.underlineView_PaddingLeftConstraint.constant = xOffset;
        }
            break;
        default:
            break;
    }
    
}

- (void) updateStackViewDisplayModeWithIndex:(int) index{
    NSArray * image = @[ [UIImage imageNamed:@"icon_mode_photo"], [UIImage imageNamed:@"icon_mode_post"], [UIImage imageNamed:@"icon_mode_album"] ];
    
    NSArray * activeImage = @[ [UIImage imageNamed:@"icon_mode_photo_active"], [UIImage imageNamed:@"icon_mode_post_active"], [UIImage imageNamed:@"icon_mode_album_active"] ];
    
    
    for (int i = 0; i < self.stackViewDisplayMode.subviews.count; i++) {
        UIButton * button = (UIButton *)self.stackViewDisplayMode.subviews[i];
        if (i == index) {
            [button setImage:activeImage[i] forState:UIControlStateNormal];
        }else{
            [button setImage:image[i] forState:UIControlStateNormal];
        }
        
    }
}

- (void)configCell:(out_profile_fetch *)profile{
    if (profile) {
        self.lblDisplayName.text = profile.name;
        self.lblUserName.text = profile.username;
        
        NSNumber * flower = [NSNumber numberWithLongLong:profile.num_received_flower + profile.flower_thankful];
        self.lblFlowersNumb.text = [flower formatThounsandStyle];
        
        if(profile.num_received_flower + profile.flower_thankful <= 1)
        {
            self.lblFlowersDesc.text = [AppHelper getLocalizedString:@"FLOWERName.Title"];
        }else{
            self.lblFlowersDesc.text = [AppHelper getLocalizedString:@"FLOWERSName.Title"];
        }
        
        self.lblFollowers.text = [[NSNumber numberWithInteger:profile.follower] formatThounsandStyle];
        if (profile.follower <= 1) {
            self.lblFollowersDesc.text = [AppHelper getLocalizedString:@"GiverName.Title"];
        } else {
            self.lblFollowersDesc.text = [AppHelper getLocalizedString:@"GiversName.Title"];
        }
        
        self.lblFollowing.text = [[NSNumber numberWithInteger:profile.following] formatThounsandStyle];
        if (profile.following <= 1) {
            self.lblFollowingDesc.text = [AppHelper getLocalizedString:@"RecieverName.Title"];
        } else {
            self.lblFollowingDesc.text = [AppHelper getLocalizedString:@"RecieversName.Title"];
        }

    }
}


- (IBAction)btnEditAvatar_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnEditAvatar_Pressed)]) {
        [self.delegate btnEditAvatar_Pressed];
    }
}

- (IBAction)btnEditProfile_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnEditProfile_Pressed)]) {
        [self.delegate btnEditProfile_Pressed];
    }
    
}

- (IBAction)btnEditBio_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnEditBio_Pressed)]) {
        [self.delegate btnEditBio_Pressed];
    }
}

- (IBAction)btnFollowers_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnFollowers_Pressed)]) {
        [self.delegate btnFollowers_Pressed];
    }
}

- (IBAction)btnFollowing_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnFollowing_Pressed)]) {
        [self.delegate btnFollowing_Pressed];
    }
}

- (IBAction)btnAchivement_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnAchivement_Pressed)]) {
        [self.delegate btnAchivement_Pressed];
    }
}

- (IBAction)btnChat_Pressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(btnChat_Pressed)]) {
        [self.delegate btnChat_Pressed];
    }
}

- (IBAction)btnPhoto_Pressed:(id)sender {
    [self selectedDisplayMode:PHOTOS];
    if ([self.delegate respondsToSelector:@selector(switchDisplayMode:)]) {
        [self.delegate switchDisplayMode:0];
    }
    
}

- (IBAction)btnPost_Pressed:(id)sender {
    [self selectedDisplayMode:POSTS];
    if ([self.delegate respondsToSelector:@selector(switchDisplayMode:)]) {
        [self.delegate switchDisplayMode:1];
    }
}

- (IBAction)btnAlbum_Pressed:(id)sender {
    [self selectedDisplayMode:ALBUMS];
    if ([self.delegate respondsToSelector:@selector(switchDisplayMode:)]) {
        [self.delegate switchDisplayMode:2];
    }
}

@end
